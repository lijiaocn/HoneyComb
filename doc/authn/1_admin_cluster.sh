#!/bin/bash
openssl req -new  -out admin_cluster/admin_cluster.csr -config ./req/admin_cluster.req.config
openssl x509 -req -days 365 -in ./admin_cluster/admin_cluster.csr -CA ./CA/ca.pem -CAkey ./CA/ca-key.pem -CAcreateserial -out ./admin_cluster/admin_cluster-cert.pem
