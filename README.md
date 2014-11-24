| [*Makers Academy*](http://www.makersacademy.com) | Week 6 - Project|
| ---------------- | ------ |

Bookmark Manager
================

![alt text](/public/images/bookmark_manager_screenshot.png)


This week's project is a bookmark manager. The goal is to learn about integration testing with Capybara, relational databases, and security considerations.

The app is live [here](https://ruthsbmmanager.herokuapp.com/). A user can sign up for a new account, log in or out, and add new links. The website is able to show links from the database and filter links by tags.

Technologies used:
- Ruby
- Sinatra
- DataMapper
- RSpec
- Capybara
- HTML5
- CSS3
- PostgreSQL
- Mailgun
- Heroku
- BCrypt
- New Relic

How to run tests
----------------
Clone the repository:
```shell
$ git@github.com:ruthearle/BookmarkManager.git
```

Change into the directory:
```shell
$ cd BookmarkManager
```

Install all dependencies:
```shell
$ bundle install
```

Create a local database:
```shell
$ psql
  =# CREATE DATABASE bookmark_manager_test;

  =# \q
```

Run the auto-upgrade task:
```shell
$ rake auto_upgrade
```

Create an environment variable pointing to your local database and
MailGun API key and smtp login (you will need to grab your key and login by
signing up for an account at [MailGun](http://mailgun.com) and replace
the fake info after the '='):
```shell
$ export DATABASE_URL=postgres://localhost/bookmark_manager_test
$ export MAILGUN_API_KEY=key-111111111111111111111111
$ export MAILGUN_SMTP_LOGIN=postmaster@111111111.mailgun.org
```

Run RSpec:
```shell
$ rspec
```
