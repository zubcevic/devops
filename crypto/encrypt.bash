#!/bin/bash

d_test="Hello World"

d_enc=$(echo $d_test | openssl enc -aes-256-cbc -k secret | openssl base64)

printf -- "encrypted value: %s\n" "$d_enc"

d_orig=$(echo $d_enc| openssl base64 -d | openssl enc -d -aes-256-cbc -k secret)

printf -- "decrypted value: %s\n" "$d_orig"



