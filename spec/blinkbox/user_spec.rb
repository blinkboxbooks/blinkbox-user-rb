require_relative '../spec_helper'
require_relative '../../lib/blinkbox/user'
include Blinkbox

class MockClient
	def initialize server_uri,proxy_uri

	end
	def authenticate credentials

	end
	def last_response params={}
		return {:A => 'A', :B => 'B'}
	end
end

describe client_settings do
	it { is_expected.to respond_to(:server_uri) }
	it { is_expected.to respond_to(:proxy_uri) }
end

describe User.new({ :grant_type => "password",
	:username => "test",:password => "password"}, MockClient ) do
	it { is_expected.to respond_to(:get_clients) }
	it { is_expected.to respond_to(:register_client).with(1).argument }
	it { is_expected.to respond_to(:deregister_client).with(1).argument }
	it { is_expected.to respond_to(:deregister_client_all)}


end
