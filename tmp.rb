require_relative 'lib/blinkbox-user'
include Blinkbox

u = User.new({:grant_type => "password",:username => "calabash_test@gmail.com", :password => "password"})

u.deregister_client_all
