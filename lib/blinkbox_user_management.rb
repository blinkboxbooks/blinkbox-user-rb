require 'httparty'
require 'multi_json'
require 'net/http/capture'

module UserManagement
	class User
		def has_attribute? key
			@attributes.has_key? key
		end
		def expired?
			def get_token
				@attributes['access_token']
			end
			def initialize(json_blob)
				@attributes = json_blob
			end
			def [](y)
				if has_attribute? y
					return @attributes[y]
				else
					return nil
				end
			end
		end
		class UserManager
			include HTTParty
			def initialize server_uri, proxy_uri = nill
				self.class.base_uri(server_uri.to_s)
				self.class.http_proxy(proxy_uri.host, proxy_uri.port, proxy_uri.user, proxy_uri.password) if proxy_uri
				@headers = {}
			end
			def get_user email, password
				params = {
					"grant_type" => "password",
					"username" => email,
					"password" => password
				}
				http_send :post, "/oauth2/token",params
				return !HttpCapture::RESPONSES.last.body.empty? ? User.new(MultiJson.load(HttpCapture::RESPONSES.last.body)) : nil
			end
			def get_clients user
				http_send :get, "/clients",{},user.get_token
				MultiJson.load(HttpCapture::RESPONSES.last.body)["clients"]
			end
			def delete_client user, id
				http_send :delete, "/clients/#{id}",{},user.get_token
			end
			def delete_all_clients user
				get_clients(user).each do | client|
				delete_client user, client["client_id"]
				end
			end
			private
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
end
