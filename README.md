# CertifyEmail

This is a thin wrapper for the [Email API](https://github.com/USSBA/email_api) to handle basic GET and POST operations for email entries.


#### Table of Contents
- [Installation](#installation)
- [Usage](#usage)
    - [Configuration](#configuration)
    - [Email](#email)
- [Error Handling](#error&nbsp;handling)
- [Logging](#logging)
- [Development](#development)
- [Publishing](#publishing)
- [Changelog](#changelog)

## Installation

There are three options you can use to install the gem. Pulling from the private sba-one gem server, building it manually, or installing directly from GitHub.

### Pulling from private geminabox (preferred)

Ensure you have the credentials configured with bundler, then add the following to your Gemfile:
```
source 'https://<domain-of-our-private-gem-server>/' do
  gem 'certify_documents'
end
```

### Install from GitHub

Add the following to your Gemfile to bring in the gem from GitHub:

```
gem 'certify_email', git: 'git@github.com:SBA-ONE/certify_email.git', branch: 'develop'
```

This will pull the head of the develop branch in as a gem.  If there are updates to the gem repository, you will need to run `bundle update certify_email` to get them.

### Building it manually

* Pull down the latest branch for the gem
* `bundle install` to build it
* You can run tests `rspec` to make sure it built okay.
* Then `rake build` to build the gem, this builds the .gem file in /pkg
* Jump over to the folder of the the app where you want to use them and follow the instructions below within that app/repo, for example, if working with the [Shared-Services Prototype](https://github.com/SBA-ONE/shared-services-prototype):
  * Copy the .gem into the folder `vendor/gems/certify_email`
  * In the app where you want to use the gem, do `gem install <path to gem>` e.g. `gem install vendor/gems/certify_email/certify_email-0.1.0.gem`
  * add `gem 'certify_email'` to your Gemfile
  * `bundle install`
  * If this worked correctly, you should see `certify_email` in your `Gemfile.lock`

## Usage

### Configuration
Set the Certify Email API URL in your apps `config/initializers` folder, you probably also want to include an `email.yml` under `config` to be able to specify the URL based on your environment.

```
CertifyEmail.configure do |config|
  config.api_url = "http://localhost:3008"
  config.api_version = 1
  config.excon_timeout = 5
end
```

### Email

This gem will send a request to the Email API to a given email address with the send method. This method requires that the address, a message, and the template used to format the email be passed in as parameters. Currently the only available template is the "basic_template".
```
CertifyEmail::Email.send_email(
  recipient: 'foo@bar.com',
  message: 'This is a message',
  template: 'basic_template',
  subject: 'This is a subject'
)
```


## Error Handling
* Calling a Gem method with no or empty parameters, e.g.:
```
CertifyEmail::Email.send ()
```
will return a bad request:
`{body: "Bad Request: No parameters submitted", status: 400}`
* Calling a Gem method with invalid parameters:
```
CertifyEmail::Email.send (foo: 'bar')
```
will return an unprocessable entity error:
`{body: "Unprocessable Entity: Invalid parameters submitted", status: 422}`
* Any other errors that the Gem experiences when connecting to the API will return a service error and the Excon error class:
`    {body: "Service Unavailable: There was a problem connecting to the API. Type: Excon::Error::Socket", status: 503}`

## Logging
Along with returning status error messages for API connection issues, the gem will also log connection errors.  The default behavior for this is to use the built in Ruby `Logger` and honor standard log level protocols.  The default log level is set to `debug` and will output to `STDOUT`.  This can also be configured by the gem user to use the gem consumer application's logger, including the app's environment specific log level.
```
# example implementation for a Rails app
CertifyEmail.configure do |config|
  config.logger = Rails.logger
  config.log_level = Rails.configuration.log_level
end
```

## Development
After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [artifactory](https://rubygems.org).

Use `console` to access the pry console and add the API URL to the gem's config to be able to correctly test commands:
```
CertifyEmail.configuration.api_url="http://localhost:3008"
```
While working in the console, you can run `reload!` to reload any code in the gem so that you do not have to restart the console.  This should not reset the manual edits to the `configuration` as noted above.

## Publishing
To release a new version:
  1. Bump the version in lib/\*/version.rb
  1. Merge into `master` (optional)
  1. Push a tag to GitHub in the form: `X.Y.Z` or `X.Y.Z.pre.myPreReleaseTag`
 At this point, our CI process will kick-off, run the tests, and push the built gem into our Private Gem server.

## Changelog
Refer to the changelog for details on API updates. [CHANGELOG](CHANGELOG.md)
