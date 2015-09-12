#!/bin/bash
openssl req -new  -out user_guest/user_guest.csr -config ./req/user_guest.req.config
openssl x509 -req -days 365 -in ./user_guest/user_guest.csr -CA ./CA/ca.pem -CAkey ./CA/ca-key.pem -CAcreateserial -out ./user_guest/user_guest-cert.pem
