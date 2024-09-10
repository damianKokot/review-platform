#!/bin/sh

# Import PGP Key if exported
if [[ "$PGP_KEY_BASE64" != "" ]]; then
  printenv PGP_KEY_BASE64 | base64 -d | gpg --import &> /dev/null
fi
# Import id_rsa file if exported
if [[ "$ID_RSA_BASE64" != "" ]]; then
  mkdir -p /root/.ssh
  printenv ID_RSA_BASE64 | base64 -d > /root/.ssh/id_rsa
  chmod 400 /root/.ssh/id_rsa
fi

if [[ $1 == "sops_encrypt" ]]; then
  decrypted_suffix=$2
  encrypted_suffix=$3
  echo -n "Encrypting $decrypted_suffix to $encrypted_suffix... "
  find . -regex ".*/$decrypted_suffix$" -exec sh -c "sops encrypt {} > \$(echo {} | sed 's/$decrypted_suffix/$encrypted_suffix/g')" \; && echo "OK"
  exit 0;
fi

if [[ $1 == "sops_decrypt" ]]; then
  encrypted_suffix=$1
  decrypted_suffix=$2
  echo -n "Decrypting $decrypted_suffix to $encrypted_suffix... "
  find . -regex ".*/$encrypted_suffix$" -exec sh -c "sops decrypt {} > \$(echo {} | sed 's/$encrypted_suffix/$decrypted_suffix/g')" \; && echo "OK"
  exit 0;
fi

[[ "$WORKDIR" != "" ]] && cd $WORKDIR
exec "$@"
