require_relative '../spec_helper'
require_relative '../../lib/blinkbox/user'
include Blinkbox

TESTDATA = {  :access_token => "eyJraWQiOiJibGlua2JveC9wbGF0L2VuYy9yc2EvMSIsImN0eSI6IkpXVCIsImVuYyI6IkExMjhHQ0 \
        0iLCJhbGciOiJSU0EtT0FFUCJ9.RDGUMvxMG44WKImdMAFFWypaKCmFOCwCqDq24yJobqOjrmfR7V4ZErJTO-xWueqQX5SxzgRui \
        ARNVch5SdfWZZZqkAVupeiQ7_dvffeEdEGm8RtGiCs9f37s9TNayCQOgWiC4aGEQ2JQ20rt2pLF9SkXmuTqLgVRQCZdrAwtzC90G \
        SVRhAI39nIzsBnxhYxGsv12N9-89g1F6q8NTtih19A3jWBKIhFRp4dC21T1vQDw-k6hiPDqbo9G8msC9-U9aoXZToh9y2YjPxAus \
        rXCPlOTX9r6tMW1RtTFHHDiI48EA7z23ItqhhaiweZVnwjGl3RPWPAwgxgGFyhOcWD10w.Ul73uvPewy1LUqZQ.n0hxUwxsf2fIZ \
        11xl8nprsbxr8naI51cdroNOylsrSRrVy551_1e0d0DsmoSfmvOkECOLFNaxeC2qDBQYKH7pCpOWmtOuxpWdBvxGC_MV9-z_kapr \
        UrdmJMSxLkM7Ehh9Z1n254wv-zUS8vJ8Dr-e3DwMIKA81OhoGJtNAg6cphGFFFfPmaEOfeP1oHp-SuDYCi6CJSrJRM-TO4HvJqbX \
        QaHqGSdLAvkTe_fGpDofwpGqEUV7bf7gY_U7cvB-5l3gYmkLFs8Ic-xI6a8lhISXrJLup_Pr5pfHTKuRPdYBWY187K_-lDeF0zJA \
        XOxnfdUhGcrxEM.ObXF30ih4PvbRqv_qzoYdQ",
              :token_type => "bearer",
              :expires_in => 1800,
              :refresh_token => "kWLx_RPKbZUYjH8bk8gHm3LKpkuR2MfMXy25ATmv2pc",
              :user_id => "urn:blinkbox:zuul:user:10921",
              :user_uri => "/users/10921",
              :user_username => "calabash_test@gmail.com",
              :user_first_name => "Firstname",
              :user_last_name => "Lastname"
}

class MockClient
  def initialize(*)
  end

  def authenticate(*)
  end

  def last_response(*)
    TESTDATA
  end
end

describe client_settings do
  it { is_expected.to respond_to(:server_uri) }
  it { is_expected.to respond_to(:proxy_uri) }
end

describe User.new({ :grant_type => "password",
                    :username => "test", :password => "password" }, MockClient) do
  it { is_expected.to respond_to(:get_clients) }
  it { is_expected.to respond_to(:register_client).with(1).argument }
  it { is_expected.to respond_to(:deregister_client).with(1).argument }
  it { is_expected.to respond_to(:deregister_client_all) }

  it "Should store authentication data" do
    @user = User.new({ :grant_type => "password",
                       :username => "test", :password => "password" }, MockClient)
    expect(@user.access_token).to eq(TESTDATA[:access_token])
    expect(@user.token_type).to eq(TESTDATA[:token_type])
    expect(@user.expires_in).to eq(TESTDATA[:expires_in].to_s)
    expect(@user.user_id).to eq(TESTDATA[:user_id])
    expect(@user.refresh_token).to eq(TESTDATA[:refresh_token])
    expect(@user.user_id).to eq(TESTDATA[:user_id])
    expect(@user.user_uri).to eq(TESTDATA[:user_uri])
    expect(@user.user_username).to eq(TESTDATA[:user_username])
    expect(@user.user_first_name).to eq(TESTDATA[:user_first_name])
    expect(@user.user_last_name).to eq(TESTDATA[:user_last_name])
  end
end
