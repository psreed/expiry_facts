#!/bin/sh
# Helpful Links: 
#    https://ss64.com/ps/syntax-dateformats.html
#    https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/get-date?view=powershell-7.1
#    https://stackoverflow.com/questions/21297853/how-to-determine-ssl-cert-expiration-date-from-a-pem-encoded-certificate

$PUPPET="C:\Program Files\Puppet Labs\Puppet\bin\puppet.bat"
$CERT=$(& ${PUPPET} config print hostcert)

$END=$(((openssl x509 -enddate -noout -in ${CERT}) -Split "=" )[1]) -replace '  ',' '
$END=$END -replace ".{3}$",'+00'
$END=[datetime]::parseexact($END,'MMM d HH:mm:ss yyyy zz',$null)
$END=(Get-Date ${END} -uformat %s)

$START=((((openssl x509 -startdate -noout -in ${CERT}) -Split "=" )[1]) -replace '  ',' ')
$START=(${START} -replace ".{3}$",'+00')
$START=([datetime]::parseexact(${START},'MMM d HH:mm:ss yyyy zz',$null))
$START=(Get-Date ${START} -uformat %s)

$SIXMONTHS=Get-Date -Date ((Get-Date).AddMonths(6)) -uformat %s

write-host "{";
write-host "  `"puppet_cert`": {"

write-host "    `"hostcert`": `"${CERT}`","

write-host "    `"start_date`": `"" -NoNewline
write-host (([System.DateTimeOffset]::FromUnixTimeSeconds($START)).DateTime).ToString("s") -NoNewline
write-host "`","

write-host "    `"end_date`": `"" -NoNewline
write-host (([System.DateTimeOffset]::FromUnixTimeSeconds($END)).DateTime).ToString("s") -NoNewline
write-host "`","

write-host "    `"expiry_under_6_months`": " -NoNewline
if ($END -lt $SIXMONTHS) {
  write-host "true"
}
else {
  write-host "false"
}

write-host "  }"
write-host "}"