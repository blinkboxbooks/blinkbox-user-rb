require_relative '../spec_helper'
require_relative '../../lib/blinkbox/zuulclient'
include Blinkbox

describe ZuulClient.new(SERVER_URI, nil) do
	it { is_expected.to respond_to(:get_client_info).with(2).arguments }
	it { is_expected.to respond_to(:get_clients_info).with(1).argument }
	it { is_expected.to respond_to(:authenticate).with(1).argument }
	it { is_expected.to respond_to(:use_proxy).with(1).argument }
	it { is_expected.to respond_to(:get_user_info).with(2).arguments }
	it { is_expected.to respond_to(:get_access_token_info).with(1).argument }
	it { is_expected.to respond_to(:extend_elevated_session).with(1).argument }
	it { is_expected.to respond_to(:register_client).with(2).arguments }
	it { is_expected.to respond_to(:change_password).with(2).arguments }
	it { is_expected.to respond_to(:reset_password).with(1).argument }
	it { is_expected.to respond_to(:validate_password_reset_token).with(1).argument }
	it { is_expected.to respond_to(:deregister_client).with(2).arguments }
	it { is_expected.to respond_to(:revoke).with(2).arguments }
	it { is_expected.to respond_to(:update_client).with(2).arguments }
	it { is_expected.to respond_to(:update_user).with(2).arguments }

end
