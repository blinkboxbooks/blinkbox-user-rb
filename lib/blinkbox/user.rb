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
		def initialize params
			@user_credentials = params
			if !params[:custom_http_client]	
				@client = ZuulClient.new Settings.client_settings.server_uri,
					Settings.client_settings.proxy_uri
			else
				@client = params[:custom_http_client]
			end
			@client.authenticate(@user_credentials)
			if !params[:custom_datasource]
				res = last_response({:format => "json"})
			else
				res = params[:custom_datasource]
			end
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
		def deregister_client client_id
			@client.deregister_client client_id, @access_token 
		end
		def deregister_client_all	
			get_clients.each do | client |
				localid = client['client_id'].split(":").last
			deregister_client localid 
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
