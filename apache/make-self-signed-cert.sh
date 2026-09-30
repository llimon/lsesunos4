mkdir ssl.crt
mkdir ssl.key
openssl req -x509 -nodes -days 365 -newkey rsa:1024 \
  -keyout ssl.key/server.key \
  -out ssl.crt/server.crt \
  -subj "/C=US/ST=CA/L=Localhost/O=Development/CN=marlin"

chmod 600 ssl.key/server.key
chmod 644 ssl.crt/server.crt

echo "New self-signed certificate and key have been created under"
echo "You can copy them by hand or commenting the exit 1 in this script."
echo "Certificate and key should be instaled in:"
echo " /usr/local/lse/apache/conf/ssl.crt/server.crt"
echo " /usr/local/lse/apache/conf/ssl.key/server.key"

ls -al ssl.crt/
ls -al ssl.key/


exit 1

cp ssl.crt/server.crt /usr/local/lse/apache/conf/ssl.crt/server.crt
cp ssl.key/server.key /usr/local/lse/apache/conf/ssl.key/server.key
