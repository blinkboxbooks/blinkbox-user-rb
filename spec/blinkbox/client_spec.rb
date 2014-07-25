require_relative '../spec_helper'

include Blinkbox

describe ZuulClient.new(SERVER_URI,nil) do
	it { is_expected.to respond_to(:get_client_info).with(2).arguments }
	it { is_expected.to respond_to(:get_clients_info).with(1).argument }
end
