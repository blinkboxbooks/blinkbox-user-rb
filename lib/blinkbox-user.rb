require_relative 'blinkbox-client'

module Blinkbox
  module ClientApi
    module Settings

      class ActiveSettings
        attr_reader :server_uri, :proxy_uri
        def initialize params
          @server_uri = params[:server_uri] || "https://auth.blinkboxbooks.com"
          @proxy_uri = params[:proxy_uri] || nil
          @http_auth = params[:http_method]
        end
      end
    end

    class User < Client
      attr_reader :attributes
      def initialize params
        @user_credentials = params
        @attributes = {}
        @action_queue = []
        super Settings::ActiveSettings.client_settings.server_uri,
        Settings::ActiveSettings.client_settings.proxy_uri
      end
      def refresh
        authenticate(@user_credentials)
        @attributes = last_response({:format => "json"})
      end
      def last_response params={}
        case params[:format]
        when "json"
          MultiJson.load(HttpCapture::RESPONSES.last.body)
        else
          HttpCapture::RESPONSES.last
        end
      end
      def method_missing(name, *args, &blk)
        if args.empty? && blk.nil? && @attributes.has_key?(name.to_s)
          @attributes[name.to_s]
        else
          super
        end
      end
    end
    def client_settings(params ={})
      @configuration ||= Settings::ActiveSettings.new params
    end
  end
end
