#!/bin/sh
# Helpful Links:
#   https://git.gnupg.org/cgi-bin/gitweb.cgi?p=gnupg.git;a=blob_plain;f=doc/DETAILS

GPGDIR=/etc/pki/rpm-gpg
echo "{"
echo "  \"gpg_rpm_gpg_dir\": \"${GPGDIR}\","
echo "  \"gpg_pub_keys\":"
echo "  {"
CNT=0
EXPIRY_WARNINGS=0;
if [ -d "${GPGDIR}" ] && [ ! -z "${GPGDIR}" ]; then
  for i in $GPGDIR/*
  do
## Get a Key
    KEY=`cat ${i} | gpg --with-colon --fixed-list-mode 2>/dev/null`
    KEYID=`echo ${KEY} | cut -d: -f5`
    if [ $CNT -gt 0 ]; then echo ","; fi

    echo "    \"${KEYID}\": {"



## Output the Key in colon format
    echo -n "      \"key_info\": \""
    echo -n `echo $KEY | sed 's/\\\/\\\\\\\/g'`
    echo "\","

## Output key status
    STATUS=`echo $KEY | cut -d: -f2`
    if [ "${STATUS}" == "e" ]; then STATUS="EXPIRED"; fi
    echo "      \"key_status\": \"${STATUS}\","

## Output expiry date
    EXDATE=`echo $KEY | cut -d: -f7`
    echo -n "      \"expiry_date\": \""
    if [ "${EXDATE}" != "" ]; then echo -n `date -d @${EXDATE}`; fi
    echo "\"",

## Output Expiry Warning
    SIXMONTHS=`date --date='+6 months' +%s`
    echo -n "      \"expiry_under_6_months\": "
    if [ "${EXDATE}" != "" ]; then
      if [ "${EXDATE}" -lt "${SIXMONTHS}" ]; then
        echo "true"
        EXPIRY_WARNINGS=$((EXPIRY_WARNINGS+1))
      else
        echo "false"
      fi
    else
      echo "\"\""
    fi

    echo -n "    }"

    CNT=$((CNT+1))
  done
fi
echo ""
echo "  },"
echo "  \"gpg_key_count\": ${CNT},"
echo "  \"gpg_expiry_warnings\": ${EXPIRY_WARNINGS}"
echo "}"