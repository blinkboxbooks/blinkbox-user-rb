require 'httparty'
require 'multi_json'
require 'net/http/capture'
module UserManagement
	class User
		include HTTParty
		def initialize(server_uri, email, password)
			self.class.base_uri(server_uri.to_s)
			@headers = {}
			params = {
				"grant_type" => "password",
				"username" => email,
				"password" => password
			}
			http_send :post, "/oauth2/token",params
			@attributes = MultiJson.load(HttpCapture::RESPONSES.last.body)
		end
		def has_attribute? key
			@attributes.has_key? key
		end
		def get_token
			raise "No token found" if !has_attribute? 'access_token'
			@attributes['access_token']
		end
		def [](y)
			if has_attribute? y
				return @attributes[y]
			else
				return nil
			end
		end
		def get_clients
			http_send :get, "/clients",{},get_token
			MultiJson.load(HttpCapture::RESPONSES.last.body)["clients"]
		end
		def delete_client uri
			http_call(:delete,uri,{},get_token)	
		end
		def delete_all_clients 
			get_clients.each do | client|
			delete_client client["client_uri"]
			end
		end
		private
		def http_call(verb, uri, params = {}, access_token = nil)
			headers = { "Accept" => "application/json" }.merge(@headers)
			headers["Authorization"] = "Bearer #{access_token}" if access_token
			self.class.send(verb, uri.to_s, headers: headers, query: params)
			HttpCapture::RESPONSES.last
		end
		def http_send(verb, uri, body_params, access_token = nil)
			headers = { "Accept" => "application/json", "Content-Type" => "application/x-www-form-urlencoded" }.merge(@headers)
			headers["Authorization"] = "Bearer #{access_token}" if access_token
			body_params.reject! { |k, v| v.nil? }
			body_params = URI.encode_www_form(body_params) unless body_params.is_a?(String)
			self.class.send(verb, uri.to_s, headers: headers, body: body_params)
			HttpCapture::RESPONSES.last
		end
	end
end

