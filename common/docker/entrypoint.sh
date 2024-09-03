#!/bin/sh

# Import PGP Key if exported
if [[ "$PGP_KEY_BASE64" != "" ]]; then
  printenv PGP_KEY_BASE64 | base64 -d | gpg --import &> /dev/null
fi

function sops_encrypt() {
  decrypted_suffix=$1
  encrypted_suffix=$2
  echo -n "Encrypting $decrypted_suffix to $encrypted_suffix... "
  find . -regex ".*/$decrypted_suffix$" -exec sh -c "sops encrypt {} > \$(echo {} | sed 's/$decrypted_suffix/$encrypted_suffix/g')" \; && echo "OK"
}

function sops_decrypt() {
  encrypted_suffix=$1
  decrypted_suffix=$2
  echo -n "Decrypting $decrypted_suffix to $encrypted_suffix... "
  find . -regex ".*/$encrypted_suffix$" -exec sh -c "sops decrypt {} > \$(echo {} | sed 's/$encrypted_suffix/$decrypted_suffix/g')" \; && echo "OK"
}

eval $@
