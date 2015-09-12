#!/bin/bash
openssl req -new  -out user_alice/user_alice.csr -config ./req/user_alice.req.config
openssl x509 -req -days 365 -in ./user_alice/user_alice.csr -CA ./CA/ca.pem -CAkey ./CA/ca-key.pem -CAcreateserial -out ./user_alice/user_alice-cert.pem
