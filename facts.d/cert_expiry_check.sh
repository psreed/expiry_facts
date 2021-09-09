#!/bin/sh
# $(puppet config print hostcert)

CERT=$(puppet config print hostcert)

END=`openssl x509 -enddate -noout -in ${CERT} | cut -d= -f2`
END=`date --date="${END}" +%s`

START=`openssl x509 -startdate -noout -in ${CERT} | cut -d= -f2`
START=`date --date="${START}" +%s`

SIXMONTHS=`date --date="+6 months" +%s`

echo "{";
echo "  \"puppet_cert\": {"

echo "    \"hostcert\": \"${CERT}\","

echo -n "    \"start_date\": \""
echo -n `date -d @${START}`
echo "\","

echo -n "    \"end_date\": \""
echo -n `date -d @${END}`
echo "\","

echo -n "    \"expiry_under_6_months\": "
if [ "${END}" -lt "${SIXMONTHS}" ]; then
  echo "true"
else
  echo "false"
fi

echo "  }"
echo "}"