# Change log

## 0.2.0 ([#6](https://git.mobcastdev.com/TEST/blinkbox-user/pull/6) 2014-08-12 10:29:41)

Improving and adding Device object for easier API usage

breaking change

Adding device object to hide some of the uglier calls from user.

## 0.1.0 ([#5](https://git.mobcastdev.com/TEST/blinkbox-user/pull/5) 2014-07-28 14:51:24)

Refactoring and improvements

new feature

- Split out user and client
- User generates json data as instance variables
- created high level API for device deregistering
- Unit tests with mocks 

## 0.0.4 ([#4](https://git.mobcastdev.com/TEST/blinkbox-user/pull/4) 2014-07-24 10:56:45)

Fix up the namespacing to be consistant with other Blinkbox libs/gems

### Patch

- Fix up the namespacing such that it's required as 'blinkbox/user' and the class is Blinkbox::User
- Correct the associated RSpec test layout
- Fix the whitespacing to use 2-space soft-tabs
- Add in a missing runtime dependancy

## 0.0.3 ([#3](https://git.mobcastdev.com/TEST/blinkbox-user/pull/3) 2014-07-22 09:55:19)

Very basic test addition

Improvement
- Added basic spec integration test (Not stubbing a service - using live)

## 0.0.2 ([#2](https://git.mobcastdev.com/TEST/blinkbox-user/pull/2) 2014-07-21 16:29:44)

Inherit dependancies from the gemspec, and add in sources

Patch to clean up gem deps to come from the Gemspec instead of Gemfile.

