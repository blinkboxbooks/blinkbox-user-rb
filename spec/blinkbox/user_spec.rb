require_relative '../spec_helper'

include Blinkbox

class MockClient
	def authenticate credentials
	end
end

describe client_settings do
	it { is_expected.to respond_to(:server_uri) }
	it { is_expected.to respond_to(:proxy_uri) }
end

describe User.new({:username => "test",:password => "password", :custom_http_client => MockClient.new,
:custom_datasource => {:A => "A", :B => "B", :C => "C"}} ) do
	it { is_expected.to respond_to(:get_clients) }	
	it { is_expected.to respond_to(:register_client).with(1).argument }	
	it { is_expected.to respond_to(:deregister_client).with(1).argument }	
	it { is_expected.to respond_to(:deregister_client_all)}	
end
