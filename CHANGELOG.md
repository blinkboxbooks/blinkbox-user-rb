# Change log

## 0.5.3 ([#20](https://git.mobcastdev.com/TEST/blinkbox-user/pull/20) 2015-01-27 16:22:26)

patch handle error response from register call

patch

## 0.5.2 ([#19](https://git.mobcastdev.com/TEST/blinkbox-user/pull/19) 2015-01-27 16:01:40)

minor patch to simplify

patch

## 0.5.1 ([#18](https://git.mobcastdev.com/TEST/blinkbox-user/pull/18) 2015-01-27 15:43:46)

Blinkbox::User#register_device should take in Hash and convert to Device object internally - improvement

patch: #register_device currently requires usage of its internal class Device instead of conveniently accepting properties as a Hash. Was discovered with the first usage of #register_device method in https://git.mobcastdev.com/TEST/website-test/pull/621

Blinkbox::User.register_device should take in hash and convert it into the Device object before calling upon ZuulClient

website-test will adopt to changes in https://git.mobcastdev.com/TEST/website-test/pull/625

## 0.5.0 ([#16](https://git.mobcastdev.com/TEST/blinkbox-user/pull/16) 2015-01-14 13:49:21)

new feature: Return created card details; some code cleanup

- new feature: card details are needed by the client (e.g. to verify cardholder name or visa type)
- pass card details in expected format (keys of the card_details hash) from User class to CCclient class, so that we do not have to re-process them
- minor clean up

## 0.4.0 ([#12](https://git.mobcastdev.com/TEST/blinkbox-user/pull/12) 2015-01-12 12:29:44)

User add credit

New feature / improvement: Adding ability to add a default credit card to the user's account
https://git.mobcastdev.com/TEST/blinkbox-user/issues/11

--
Update: Changed to pull braintree key from a config file as suggested by Alex I. I didn't use the TEST_CONFIG from cucumber-blinkbox because it expects all environment data to be under hierarchy of 'server'.

## 0.3.3 ([#10](https://git.mobcastdev.com/TEST/blinkbox-user/pull/10) 2014-10-03 15:35:38)

Extend the Blinkbox::User class to passthrough Register requests to the existing ZuulClient

Patch to extend the Blinkbox::User abstraction to allow user registration via the existing ZuulClient implmentation.

## 0.3.2 ([#9](https://git.mobcastdev.com/TEST/blinkbox-user/pull/9) 2014-10-01 13:19:49)

Make the gem much less chatty by default

Patch to make debug output enabled by having the DEBUG environment variable declared.

## 0.3.1 ([#8](https://git.mobcastdev.com/TEST/blinkbox-user/pull/8) 2014-09-17 13:57:09)

Refactor the library to make it much more intuitive

Patch

## 0.3.0 ([#7](https://git.mobcastdev.com/TEST/blinkbox-user/pull/7) 2014-08-14 14:22:15)

splitting out authentication at Alex's request

breaking change

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

