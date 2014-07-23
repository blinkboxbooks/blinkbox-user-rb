require_relative 'lib/blinkbox-user'

include Blinkbox::ClientApi

puts client_settings.server_uri

u = User.new({:grant_type => "password",:username => "calabash_test@gmail.com", :password => "password"})
u.refresh


puts "Access token => " + u.access_token
puts "Token type => " + u.token_type
puts "Expiry time => " + u.expires_in

#Using vanilla client API
MultiJson.load(u.get_clients_info(u.access_token).body).each do |client|
  u.deregister_client client['client_id']u.access_token
end
