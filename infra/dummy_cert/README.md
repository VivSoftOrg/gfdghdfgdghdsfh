```
mkcert "*.example.it"

ls -l
total 16
-rw-------  1 junedm  staff  1704 Jan 24 20:46 _wildcard.example.it-key.pem
-rw-r--r--  1 junedm  staff  1529 Jan 24 20:46 _wildcard.example.it.pem

```

Create PFX 

```
openssl pkcs12 -export -out _wildcard.example.pfx -in _wildcard.example.it.pem -inkey _wildcard.example.it-key.pem -passout pass:dummyCert123 -passin pass:dummyCert123
```