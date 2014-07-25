require_relative '../spec_helper'

include Blinkbox

describe client_settings do
	it { is_expected.to respond_to(:server_uri) }
	it { is_expected.to respond_to(:proxy_uri) }
end
