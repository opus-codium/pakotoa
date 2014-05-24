# README

* Ruby version

1.9.3+ (2.0.0+ recommended).

* System dependencies

```
bundle install
```

* Configuration

A few files have to be created.  For each one, a *sample* file is available for
further guidance:

```
config/api_keys.yml
config/database.yml
config/secrets.yml
```

* Database creation

```
bin/rake db:migrate
```

* Database initialization

```
bin/rake db:seed
```

* How to run the test suite

```
bin/rake test
```
