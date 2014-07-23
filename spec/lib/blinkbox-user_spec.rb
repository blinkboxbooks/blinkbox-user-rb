require 'spec_helper'

SERVER_URI='https://auth.blinkboxbooks.com'
USERNAME='acceptancetestingbbb@gmail.com'
PASSWORD='9e6fdf08-2556-4e9e-b30a-20d97b0e3d19'

include Blinkbox::ClientApi

describe client_settings do
		it { is_expected.to respond_to(:server_uri) }
		it { is_expected.to respond_to(:proxy_uri) }
end
describe User.new({:grant_type =>"password",
	:username => USERNAME, :password => PASSWORD}) do
	it { is_expected.to respond_to(:refresh) }
	it { is_expected.to respond_to(:last_response) }
end
describe Client do

end
