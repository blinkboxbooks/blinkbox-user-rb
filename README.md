blinkbox-user
=======================

A pure ruby api for interacting with users, and their registered devices.

```ruby
require 'blinkbox/user'

u = Blinkbox::User.new(:username => "acceptancetestingbbb@example.com", :password => "abc123")

u.authenticate

# user devices interaction
devices = u.get_devices

if devices.count > 0
  u.deregister_device(devices.first)
end

u.deregister_all_devices

# user credit card interaction
u.add_default_credit_card() # adds a credit card (Mastercard by default) to the users account on environment set by environment variable 'SERVER'
u.add_default_credit_card({:card_type => 'amex'}) # adds a American Express credit card to the users account on environment set by environment variable 'SERVER'
u.add_default_credit_card({:card_type => 'amex', :braintree_env => 'qa'}) # adds a American Express credit card to the users account on qa
```
