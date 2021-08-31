# DEPRECATION NOTICE

**This project has been deprecated**

--------

# CertifyEmail
Thin wrapper for the [Email API](https://github.com/USSBA/email-api) to handle basic GET and POST operations for email entries.

#### Table of Contents
- [Installation](#installation)
- [Configuration](#configuration)
- [Methods](#methods)
- [Error Handling](#error-handling)
- [Logging](#logging)
- [Development](#development)
- [Publishing](#publishing)
- [Changelog](#changelog)
- [License](#license)
- [Contributing](#contributing)
- [Security Issues](#security-issues)

## Installation

### Pulling from private geminabox (preferred)

Ensure you have the credentials configured with bundler, then add the following to your Gemfile:
```
source 'https://<domain-of-our-private-gem-server>/' do
  gem 'certify_email'
end
```

### Install from GitHub

Add the following to your Gemfile to bring in the gem from GitHub:

```
gem 'certify_email', git: 'git@github.com:USSBA/certify_email.git', branch: 'develop'
```

This will pull the head of the develop branch in as a gem.  If there are updates to the gem repository, you will need to run `bundle update certify_email` to get them.

### Using it locally

* Clone this repository
* Add it to the Gemfile with the path:

```
gem 'certify_email', path: '<path-to-the-gem-on-your-system>'
```

## Configuration
Within the host application, set the Certify Email API URL in `config/initializers`, you probably also want to include a `email.yml` under `config` to be able to specify the URL based on your environment.

```
CertifyEmail.configure do |config|
  config.api_key = "your_api_key"
  config.api_url = "http://localhost:3000"
  config.api_version = 1
  config.excon_timeout = 5
end
```
The `api_key` is currently unused, but we anticipate adding in an API Gateway layer in the future.

## Methods
Refer to the [Email API](https://github.com/USSBA/email-api) for more complete documentation and detailed examples of method responses.

### Email
| Method | Description |
| ------ | ----------- |
| `CertifyEmail::Email.send_email( recipient: 'foo@bar.com', message: 'This is a message', template: 'basic_template', subject: 'This is a subject' )` | Send a request to the Email API for a given email address with the send method. This method requires that the address, a message, and the template used to format the email be passed in as parameters. Currently the only available template is `basic_template` |

## Error Handling

The Gem handles a few basic errors including:

* Bad Request - Raised when API returns the HTTP status code 400
* NotFound - Raised when API returns the HTTP status code 404
* InternalServerError - Raised when API returns the HTTP status code 500
* ServiceUnavailable - Raised when API returns the HTTP status code 503

Otherwise the gem will return more specific errors from the API. Refer to the API Docs for details around the specific error.

A typical error will look something like this:
```
{:body=>{"message"=>"Invalid parameters provided"}, :status=>404}
```

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
After checking out the repo, run `bundle install` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

Use `bin/console` to access the pry console and add the API URL to the gem's config to be able to correctly test commands:
```
CertifyEmail.configuration.api_url="http://localhost:3001"
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

## License
Certify Email is licensed permissively under the Apache License v2.0.
A copy of that license is distributed with this software.

## Contributing
We welcome contributions. Please read [CONTRIBUTING](CONTRIBUTING.md) for how to contribute.

We strive for a welcoming and inclusive environment for the Certify Email project.

Please follow this guidelines in all interactions:

1. Be Respectful: use welcoming and inclusive language.
2. Assume best intentions: seek to understand other's opinions.

## Security Issues
Please do not submit an issue on GitHub for a security vulnerability. Please contact the development team through the Certify Help Desk at [help@certify.sba.gov](mailto:help@certify.sba.gov).

Be sure to include all the pertinent information.

<sub>The agency reserves the right to change this policy at any time.</sub>
