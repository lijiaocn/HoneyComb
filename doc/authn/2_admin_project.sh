#!/bin/bash
openssl req -new  -out admin_project/admin_project.csr -config ./req/admin_project.req.config
openssl x509 -req -days 365 -in ./admin_project/admin_project.csr -CA ./CA/ca.pem -CAkey ./CA/ca-key.pem -CAcreateserial -out ./admin_project/admin_project-cert.pem
