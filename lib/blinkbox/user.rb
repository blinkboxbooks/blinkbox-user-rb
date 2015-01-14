require 'blinkbox/user/device'
require 'blinkbox/user/zuul_client'
require 'blinkbox/user/credit_card_service_client'
require 'blinkbox/user/braintree_encode'
require 'yaml'
require 'blinkbox/user/braintree_keys'

module Blinkbox
  class User
    attr_accessor :username, :password, :grant_type, :first_name, :last_name, :allow_marketing_communications, :accepted_terms_and_conditions

    def initialize(params, auth_client = ZuulClient, cc_service_client = CreditCardServiceClient)
      @grant_type = params[:grant_type] || "password"
      @username = params[:username]
      @password = params[:password]

      # Default parameters only used when attempting to register
      @first_name = params[:first_name] || "Testy"
      @last_name = params[:last_name] || "McTesterson"
      @accepted_terms_and_conditions = params[:accepted_terms_and_conditions] || true
      @allow_marketing_communications = params[:allow_marketing_communications] || false

      auth_server_uri = params[:server_uri] || "https://auth.dev.bbbtest2.com"
      @auth_client = auth_client.new(auth_server_uri, params[:proxy_uri])

      credit_card_service_uri = params[:credit_card_service_uri] || "https://api.dev.bbbtest2.com"
      @cc_service_client = cc_service_client.new(credit_card_service_uri, params[:proxy_uri])
    end

    def register
      @auth_client.register_user(self)
    end

    def authenticate
      @auth_client.authenticate(user_credentials)
      res = @auth_client.last_response(:format => "json")

      res.keys.each do |key|
        instance_eval %Q{
          @#{key} = "#{res[key]}"
          User.class_eval{ attr_reader key.to_sym }
      }
      end
    end

    def get_devices
      @auth_client.get_clients_info @access_token
      @device_clients = []
      @auth_client.last_response(:format => "json")['clients'].each do |dc|
        @device_clients.push(Device.new(dc))
      end
      @device_clients
    end

    def register_device(params)
      @auth_client.register_client(params, @access_token)
    end

    def deregister_device(device)
      @auth_client.deregister_client(device.id, @access_token)
    end

    def deregister_all_devices
      get_devices.each do |device|
        deregister_device(device)
      end
    end

    def add_default_credit_card(opts = {})
      # setting up defaults
      opts[:braintree_env] ||= ENV['SERVER'] || 'dev_int'
      opts[:card_type] ||= 'mastercard'

      braintree_public_key = BRAINTREE_KEYS[opts[:braintree_env].to_sym]

      card_number_map = {
          'mastercard' => '5555555555554444',
          'visa' => '4111111111111111',
          'amex' => '378282246310005',
          'discover' => '6011111111111117',
          'jcb' => '3530111333300000'
      }
      card_number = card_number_map[opts[:card_type]]
      fail "Unrecognised card_type: #{opts[:card_type]}. Please use one of #{card_number_map.keys}" if card_number.nil?

      cvv = opts[:card_type].eql?('amex') ? '1234' : '123'

      @encrypted_card_number ||= BraintreeEncryption.encrypt(card_number, braintree_public_key)
      @encrypted_cvv ||= BraintreeEncryption.encrypt(cvv, braintree_public_key)
      @encrypted_expiration_month ||= BraintreeEncryption.encrypt('8', braintree_public_key)
      @encrypted_expiration_year ||= BraintreeEncryption.encrypt('2020', braintree_public_key)

      card_details = {
          default: true,
          number: @encrypted_card_number,
          cvv: @encrypted_cvv,
          expirationMonth: @encrypted_expiration_month,
          expirationYear: @encrypted_expiration_year,
          cardholderName: 'Jimmy Jib',
          billingAddress: { line1: "48 dollis rd", locality: "London", postcode: "n3 1rd" }
      }

      @cc_service_client.add_credit_card(@access_token, card_details)
    end

    private

    def user_credentials
      { grant_type: @grant_type, username: @username, password: @password }
    end
  end
end
