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
			if !params[:http_client]	
				@client = ZuulClient.new Settings.client_settings.server_uri,
					Settings.client_settings.proxy_uri
			else
				@client = params[:http_client]
			end
			@client.authenticate(@user_credentials)
			res = last_response({:format => "json"})
			res.keys.each do | key |
				instance_eval %Q{
				@#{key} = "#{res[key]}"
				User.class_eval{attr_reader :#{key} }
				puts "Storing @#{key} with value => #{res[key]}"
			}
			end
		end
		def get_clients
			@client.get_clients_info @access_token
			last_response({:format => "json"})['clients']	
		end
		def register_client params
			@client.register_client params,@access_token
		end
		def deregister_client uri
			@client.deregister_client_uri uri, @access_token 
		end
		def deregister_client_all	
			get_clients.each do | client |
				deregister_client client['client_uri']
			end
		end
		def last_response params={}
			return nil if HttpCapture::RESPONSES.last.body.empty?
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
