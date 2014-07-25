require_relative '../spec_helper'

include Blinkbox

class MockClient
	def authenticate credentials
	end
end

mockClient = MockClient.new


describe client_settings do
	it { is_expected.to respond_to(:server_uri) }
	it { is_expected.to respond_to(:proxy_uri) }
end

describe User.new({:username => "test",:password => "password", :http_client => mockClient}) do
	
end
