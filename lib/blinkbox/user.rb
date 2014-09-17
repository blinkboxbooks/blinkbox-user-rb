require 'blinkbox/user/device'
require 'blinkbox/user/zuul_client'

module Blinkbox
  class User
    attr_accessor :username, :password, :grant_type

    def initialize(params, client = ZuulClient)
      @grant_type = params[:grant_type] || "password"
      @username = params[:username]
      @password = params[:password]

      server_uri = params[:server_uri] || "https://auth.dev.bbbtest2.com"

      @client = client.new(server_uri, params[:proxy_uri])
    end

    def authenticate
      @client.authenticate(user_credentials)
      res  = @client.last_response(:format => "json")

      res.keys.each do |key|
        instance_eval %Q{
          @#{key} = "#{res[key]}"
          User.class_eval{ attr_reader key.to_sym }
      }
      end
    end

    def get_devices
      @client.get_clients_info @access_token
      @device_clients = []
      @client.last_response(:format => "json")['clients'].each do |dc|
        @device_clients.push(Device.new(dc))
      end
      @device_clients
    end

    def register_device(params)
      @client.register_client(params, @access_token)
    end

    def deregister_device(device)
      @client.deregister_client(device.id, @access_token)
    end

    def deregister_all_devices
      get_devices.each do |device|
        deregister_device(device)
      end
    end

    private

    def user_credentials
      { :grant_type => @grant_type, :username => @username, :password => @password }
    end
  end
end
