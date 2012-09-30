# ReadMe

## Getting Started

    > gem install bundler
    > bundle install
    > rake db:migrate
    > rake db:test:prepare
    > bundle exec guard

## Development

The app is setup to separate the web application (HTML) from the API (JSON).  You will find the API controllers in the `app/controllers/api` which have their own sessions and registration controllers.

### Testing

* rspec
* cucumber
* factory_girl
* faker
* guard

### Code Quality

* simplecov
* rails_best_practices

To run the analysis:

    > rake analyzer:all

## Deployment

You should be able to deploy to Heroku using heroku-san.  The staging, demo, and production configurations can be found in `config/heroku.yml`

## Thanks

The original scaffold for this application was created by [App Scrolls](http://appscrolls.org).

> scrolls new BaseJumper -s guard jquery rails_admin rails_basics rspec cucumber capybara simple_form sqlite3 twitter_bootstrap unicorn env_yaml

The project was created with the following scrolls:

* capybara
* cucumber
* env_yaml
* guard
* jquery
* rails_admin
* rails_basics
* rspec
* sqlite3
* twitter_bootstrap
* simple_form
* unicorn

Also added:

* cancan
* role_model
