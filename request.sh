#!/bin/bash

if [ $# -lt 3 ]; then
    echo usage: $0 \<example.com\> \<test@example.com\> \<token\>
    exit 1
fi

PERL5LIB=$(dirname $0)/lib:$PERL5LIB \
le.pl \
  --key account.key \
  --csr "$1.csr" \
  --csr-key "$1.key" \
  --crt "$1.crt" \
  --generate-missing \
  --email "$2" \
  --domains "*.${1}, ${1}" \
  --handle-as dns \
  --handle-with Crypt::LE::Challenge::DigitalOcean \
  --handle-params "{\"token\":\"$3\"}" \
  --debug \
  --live \
  --api 2 \
  ${@:4}

if [ "$1.pem" -ot "$1.crt" ]; then
    cat "$1.key" "$1.crt" > "$1.pem"
fi
