#!/bin/bash
openssl req -new  -out user_bob/user_bob.csr -config ./req/user_bob.req.config
openssl x509 -req -days 365 -in ./user_bob/user_bob.csr -CA ./CA/ca.pem -CAkey ./CA/ca-key.pem -CAcreateserial -out ./user_bob/user_bob-cert.pem
