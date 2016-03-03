{"apiVersion": "abac.authorization.kubernetes.io/v1beta1", "kind": "Policy", "user":"*",         "nonResourcePath": "*", "readonly": true}
{"apiVersion": "abac.authorization.kubernetes.io/v1beta1", "kind": "Policy", "user":"admin",     "namespace": "*",              "resource": "*",         "apiGroup": "*"                   }
{"apiVersion": "abac.authorization.kubernetes.io/v1beta1", "kind": "Policy", "user":"scheduler", "namespace": "*",              "resource": "pods",                       "readonly": true }
{"apiVersion": "abac.authorization.kubernetes.io/v1beta1", "kind": "Policy", "user":"scheduler", "namespace": "*",              "resource": "bindings"                                     }
{"apiVersion": "abac.authorization.kubernetes.io/v1beta1", "kind": "Policy", "user":"kubelet",   "namespace": "*",              "resource": "pods",                       "readonly": true }
{"apiVersion": "abac.authorization.kubernetes.io/v1beta1", "kind": "Policy", "user":"kubelet",   "namespace": "*",              "resource": "services",                   "readonly": true }
{"apiVersion": "abac.authorization.kubernetes.io/v1beta1", "kind": "Policy", "user":"kubelet",   "namespace": "*",              "resource": "endpoints",                  "readonly": true }
{"apiVersion": "abac.authorization.kubernetes.io/v1beta1", "kind": "Policy", "user":"kubelet",   "namespace": "*",              "resource": "events"                                       }
{"apiVersion": "abac.authorization.kubernetes.io/v1beta1", "kind": "Policy", "user":"alice",     "namespace": "projectCaribou", "resource": "*",         "apiGroup": "*"                   }
{"apiVersion": "abac.authorization.kubernetes.io/v1beta1", "kind": "Policy", "user":"bob",       "namespace": "projectCaribou", "resource": "*",         "apiGroup": "*", "readonly": true }