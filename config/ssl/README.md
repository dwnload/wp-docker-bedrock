# SSL - certificates for development

SSL development certificates are included in this repository for demonstration purposes and should be replaced 
with genuine certificates in production.

- `localhost.key`  : the private key for your certificate.
- `localhost.crt`  : used for OCSP stapling in Nginx >=1.3.7.

These certificates are self-signed, and as such are not recognized by any CA. Do not use this for anything beyond 
local development (never use in production).

### Generate `localhost.crt`, `localhost.key`

Certificate generation based on Let's Encrypt [certificates for localhost](https://letsencrypt.org/docs/certificates-for-localhost/).

```bash
openssl req -x509 -out localhost.crt -keyout localhost.key \
  -newkey rsa:2048 -nodes -sha256 \
  -subj '/CN=localhost' -extensions EXT -config <( \
   printf "[dn]\nCN=localhost\n[req]\ndistinguished_name = dn\n[EXT]\nsubjectAltName=DNS:localhost\nkeyUsage=digitalSignature\nextendedKeyUsage=serverAuth")
```

### Reference

Nginx configuration reference: [https://www.nginx.com/blog/using-free-ssltls-certificates-from-lets-encrypt-with-nginx/](https://www.nginx.com/blog/using-free-ssltls-certificates-from-lets-encrypt-with-nginx/)
