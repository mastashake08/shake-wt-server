echo "RUNNING AND WAITING FOR CONNECTIONS"
python3.11 http_server.py --certificate tests/ssl_cert.pem --private-key tests/ssl_key.pem --verbose -q .  --host ::
