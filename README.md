# Nginx-redirect

----

Nginx-redirect is a simple Nginx server that redirects requests for a given root
domain and subdomains to a target url.

With basic terraform support, this makes creating a redirect site _fairly_
straightforward.

This project spawned from my need to create a single redirecter. It is still in
alpha.

----

## Requirements

- terraform
- google cloud credentials

## Usage

```
git clone git@github.com:dang3r/nginx-redirect.git
cd nginx-redirect
cd terraform
terraform apply
# Input the root domain that will be receiving requests for redirection
# Input a list of domains the redirecter should handle
# Input the target url that requests will be redirected to.
```

## Notes

When creating the google-cloud compute instance the server runs on, an ephemeral
IP is used. This IP must be used to configure the DNS for your given domain(s)
in order for Letsencrypt to work. This relies on a 90 second period where during
server startup, you must configure DNS. Automating this via Letsencrypt or
another service will be left for future work.
