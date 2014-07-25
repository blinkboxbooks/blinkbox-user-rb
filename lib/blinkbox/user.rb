require_relative 'client'

module Blinkbox
	class Settings
		attr_reader :server_uri, :proxy_uri
		def initialize params
			@server_uri = params[:server_uri] || "https://auth.blinkboxbooks.com"
			@proxy_uri = params[:proxy_uri] || nil
		end
	end
	def client_settings(params ={})
		@configuration ||= Settings.new params
	end
	class User
		attr_reader :attributes
		def initialize params
			@user_credentials = params
			@attributes = {}
			@zuul_client = ZuulClient.new Settings.client_settings.server_uri,
				Settings.client_settings.proxy_uri
			@zuul_client.authenticate(@user_credentials)
			@attributes = last_response({:format => "json"})
		end
		def get_token
			@attributes['access_token']
		end
		def get_clients
			@zuul_client.get_clients_info get_token
			last_response({:format => "json"})['clients']
		end
		def register_client params
			@zuul_client.register_client(params,get_token)
		end
		def deregister_client uri,token
			@zuul_client.deregister_client uri,token 
		end
		def deregister_client_all 
			get_clients.each do | client |
				deregister_client client['client_id'],get_token 
				puts client['client_id']
			end
		end
		private
		def last_response params={}
			return nil if !params
			case params[:format]
			when "json"
				MultiJson.load(HttpCapture::RESPONSES.last.body)
			else
				HttpCapture::RESPONSES.last.body
			end
		end
	end
end
