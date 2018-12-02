#!/bin/bash

printf "\nenter text to encrypt: "
read -r d_test
printf "\nenter passphrase: "
read -r -s d_passphrase


d_enc=$(echo $d_test | openssl enc -aes-256-cbc -k $d_passphrase | openssl base64)

printf -- "\nencrypted value: %s\n" "$d_enc"

d_orig=$(echo $d_enc| openssl base64 -d | openssl enc -d -aes-256-cbc -k $d_passphrase)

printf -- "\ndecrypted value: %s\n" "$d_orig"



