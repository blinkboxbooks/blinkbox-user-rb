require 'httparty'
require 'multi_json'
require 'net/http/capture'
module UserManagement
	class User
		include HTTParty
		#Initializes a User object by retrieval of oauth2 token
		#Params:
		#+server_uri+:: server_uri is the url of authentication server root 
		#+email+:: username/login name 
		#+password+:: password of mentioned username/login name
		def initialize(server_uri, email, password)
			self.class.base_uri(server_uri.to_s)
			@headers = {}
			params = {
				"grant_type" => "password",
				"username" => email,
				"password" => password
			}
			http_send :post, "/oauth2/token",params
			@attributes = MultiJson.load(get_last_response.body)
			if @attributes['error']
				raise "An error occured => #{@attributes['error']}"
			end
		end
		#Performs a lookup on the attributes hash
		#Params:
		#+key+:: Is the lookup key to search for in hash
		def has_attribute? key
			@attributes.has_key? key
		end
		#Retrieves any token that may have been retrieved at initialize
		def get_token
			raise "No token found" if !has_attribute? 'access_token'
			@attributes['access_token']
		end
		#Retrieves session details, containing token validity and expiration
		def get_session
			http_send :get, "/session",{},get_token
			MultiJson.load(get_last_response.body)
		end
		#Allows object to have direct lookup on hash kvp
		def [](y)
			if has_attribute? y
				return @attributes[y]
			else
				return nil
			end
		end
		#Performs a lookup on clients associated with the current username/login name [ session token ]
		def get_clients
			http_send :get, "/clients",{},get_token
			MultiJson.load(get_last_response.body)["clients"]
		end
		#Performs deletion of a client with the given uri, providing it belongs to the current username/login name [ session token]
		#Params:
		#+uri+:: uri of the device to be deleted e.g. /device/00001
		def delete_client uri
			http_call(:delete,uri,{},get_token)	
		end
		#Performs a deletion of all retrieved clients
		def delete_all_clients 
			get_clients.each do | client|
			delete_client client["client_uri"]
			end
		end
		private
		def get_last_response
			HttpCapture::RESPONSES.last
		end
		def http_call(verb, uri, params = {}, access_token = nil)
			headers = { "Accept" => "application/json" }.merge(@headers)
			headers["Authorization"] = "Bearer #{access_token}" if access_token
			self.class.send(verb, uri.to_s, headers: headers, query: params)
			get_last_response
		end
		def http_send(verb, uri, body_params, access_token = nil)
			headers = { "Accept" => "application/json", "Content-Type" => "application/x-www-form-urlencoded" }.merge(@headers)
			headers["Authorization"] = "Bearer #{access_token}" if access_token
			body_params.reject! { |k, v| v.nil? }
			body_params = URI.encode_www_form(body_params) unless body_params.is_a?(String)
			self.class.send(verb, uri.to_s, headers: headers, body: body_params)
			get_last_response
		end
	end
end

