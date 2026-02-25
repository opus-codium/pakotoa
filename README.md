# Pakotoa

A web application to manage X.509 Public Key Infrastructures (PKI).

## Goals

* Create and manage Certificate Authorities (CA), including chained/intermediate CAs;
* Issue Certificates from Certificate Signing Requests (CSR);
* Revoke Certificates and issue Certificate Revocation Lists (CRL);
* Manage Policies to impose constraints on Certificate issuance;

## Setup

Install as a regular Ruby on Rails application.  Setup the database with:

```sh-session
bundle exec rails db:setup
```

An initial user account must be created with:

```sh-session
bundle exec rails console
```

Then, in the Rails console:

```ruby
User.create(email: "bob@example.com", password: "secret")
```
