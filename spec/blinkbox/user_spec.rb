require_relative '../spec_helper'

describe Blinkbox::User do
  before :each do
    @user = described_class.new({ :grant_type => "password", :username => "test", :password => "password" }, MockClient)
  end

  it "should list a user's devices" do
    expect(@user).to respond_to(:get_devices)
  end

  it "should be able to unregister all of a user's devices" do
    expect(@user).to respond_to(:deregister_all_devices)
  end

  it "should allow for devices to be registered for a user" do
    expect(@user).to respond_to(:register_device).with(1).argument
  end

  it "should allow for devices to be deregistered for a user" do
    expect(@user).to respond_to(:deregister_device).with(1).argument
  end

  it "Should store authentication data" do
    @user.authenticate
    expect(@user.access_token).to eq(MockClient::TESTDATA[:access_token])
    expect(@user.token_type).to eq(MockClient::TESTDATA[:token_type])
    expect(@user.expires_in).to eq(MockClient::TESTDATA[:expires_in].to_s)
    expect(@user.user_id).to eq(MockClient::TESTDATA[:user_id])
    expect(@user.refresh_token).to eq(MockClient::TESTDATA[:refresh_token])
    expect(@user.user_id).to eq(MockClient::TESTDATA[:user_id])
    expect(@user.user_uri).to eq(MockClient::TESTDATA[:user_uri])
    expect(@user.user_username).to eq(MockClient::TESTDATA[:user_username])
    expect(@user.user_first_name).to eq(MockClient::TESTDATA[:user_first_name])
    expect(@user.user_last_name).to eq(MockClient::TESTDATA[:user_last_name])
  end
end
