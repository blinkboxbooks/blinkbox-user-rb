require_relative 'zuulclient'

module Blinkbox
	class Settings
		attr_reader :server_uri, :proxy_uri

		def initialize(params)
			@server_uri = params[:server_uri] || "https://auth.blinkboxbooks.com"
			@proxy_uri = params[:proxy_uri] || nil
		end
	end

	def client_settings(params ={} )
		@configuration ||= Settings.new(params)
	end
end

module Blinkbox
	class User

		def initialize (params, client=ZuulClient)
			@user_credentials = params

			@client = client.new(Settings.client_settings.server_uri,
			Settings.client_settings.proxy_uri)

			@client.authenticate(@user_credentials)
			res  = @client.last_response({:format => "json"})

			res.keys.each do | key |
				instance_eval %Q{
					@#{key} = "#{res[key]}"
					User.class_eval{attr_reader :#{key} }
				}
			end

		end

		def get_clients
			@client.get_clients_info @access_token
			@client.last_response({:format => "json"})['clients']
		end

		def register_client params
			@client.register_client(params,@access_token)
		end

		def deregister_client client_id
			@client.deregister_client(client_id, @access_token)
		end

		def deregister_client_all
			get_clients.each do | client |
				localid = client['client_id'].split(":").last
				deregister_client(localid)
			end
		end
	end
end
