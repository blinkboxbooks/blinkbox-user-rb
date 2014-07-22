require 'spec_helper'

SERVER_URI='https://auth.blinkboxbooks.com'
USERNAME='acceptancetestingbbb@gmail.com'
PASSWORD='9e6fdf08-2556-4e9e-b30a-20d97b0e3d19'

describe BlinkboxUser do
	before do
		@user = BlinkboxUser.new(SERVER_URI,nil)
		@auth_response = MultiJson.load(@user.authenticate({"grant_type" => "password", "username" => USERNAME,"password" => PASSWORD}).body)
	end
	it 'expect oauth token' do
		expect(@auth_response['error']).to be_nil
		expect(@auth_response['access_token']).not_to be_nil
	end
	it 'expect access_token is VALID' do
		token_information = @user.get_access_token_info @auth_response['access_token']
		expect(MultiJson.load(token_information.body)['token_status']).to eql "VALID"
	end
end
