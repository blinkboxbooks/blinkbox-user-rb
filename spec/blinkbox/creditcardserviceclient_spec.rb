require_relative '../spec_helper'

describe Blinkbox::CreditCardServiceClient.new(SERVER_URI, nil) do
  it { is_expected.to respond_to(:use_proxy).with(1).argument }
  it { is_expected.to respond_to(:add_credit_card).with(1).argument }
  it { is_expected.to respond_to(:add_credit_card).with(2).arguments }
end
