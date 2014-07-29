require 'httparty'
require 'multi_json'
require 'net/http/capture'

module Blinkbox
	class ZuulClient
		include HTTParty
		attr_accessor :headers

		def initialize(server_uri, proxy_uri = nil)
			self.class.base_uri(server_uri.to_s)
			self.class.http_proxy(proxy_uri.host, proxy_uri.port, proxy_uri.user, proxy_uri.password) if proxy_uri
			self.class.debug_output($stderr)
			@headers = {}
		end

		def use_proxy(proxy_uri)
			proxy_uri = URI.parse(proxy_uri) if proxy_uri.is_a?(String)
			self.class.http_proxy(proxy_uri.host, proxy_uri.port, proxy_uri.user, proxy_uri.password)
		end

		def authenticate(params)
			http_post "/oauth2/token", params
		end

		def get_client_info(client_id, access_token)
			http_get "/clients/#{client_id}", {}, access_token
		end

		def get_clients_info(access_token)
			http_get "/clients", {}, access_token
		end

		def get_user_info(user_id, access_token)
			http_get "/users/#{user_id}", {}, access_token
		end

		def get_access_token_info(access_token)
			http_get "/session", {}, access_token
		end

		def extend_elevated_session(access_token)
			http_post "/session", {}, access_token
		end

		def register_client(client, access_token)
			params = {
				client_name: client.name,
				client_brand: client.brand,
				client_model: client.model,
				client_os: client.os
			}
			http_post "/clients", params, access_token
		end

		def change_password(params, access_token)
			http_post "/password/change", params, access_token
		end

		def reset_password(params)
			http_post "/password/reset", params
		end

		def validate_password_reset_token(params)
			http_post "/password/reset/validate-token", params
		end

		def deregister_client(client_id, access_token)
			http_delete "/clients/#{client_id}", {}, access_token
		end

		def register_user(user, client_options = {})
			params = {
				grant_type: "urn:blinkbox:oauth:grant-type:registration",
				username: user.username,
				password: user.password,
				first_name: user.first_name,
				last_name: user.last_name,
				accepted_terms_and_conditions: user.accepted_terms_and_conditions,
				allow_marketing_communications: user.allow_marketing_communications
			}
			params.merge!(client_options)
			http_post "/oauth2/token", params
		end

		def register_user_with_client(user, client)
			client_params = {
				client_name: client.name,
				client_brand: client.brand,
				client_model: client.model,
				client_os: client.os
			}
			register_user(user, client_params)
		end

		def revoke(refresh_token, access_token = nil)
			http_post "/tokens/revoke", { refresh_token: refresh_token }, access_token
		end

		def update_client(client, access_token)
			params = {}
			params[:client_name] = client.name if client.name_changed?
			params[:client_brand] = client.brand if client.brand_changed?
			params[:client_model] = client.model if client.model_changed?
			params[:client_os] = client.os if client.os_changed?
			http_patch "/clients/#{client.local_id}", params, access_token
		end

		def update_user(user, access_token)
			params = {}
			params[:username] = user.username if user.username_changed?
			params[:password] = user.password if user.password_changed?
			params[:first_name] = user.first_name if user.first_name_changed?
			params[:last_name] = user.last_name if user.last_name_changed?
			params[:accepted_terms_and_conditions] = user.accepted_terms_and_conditions if user.accepted_terms_and_conditions_changed?
			params[:allow_marketing_communications] = user.allow_marketing_communications if user.allow_marketing_communications_changed?
			http_patch "/users/#{user.local_id}", params, access_token
		end

		def admin_find_user(params = {}, access_token)
			http_get "/admin/users", params, access_token
		end

		def admin_get_user_info(user_id, access_token)
			http_get "/admin/users/#{user_id}", {}, access_token
		end

		def last_response params={}
			res = HttpCapture::RESPONSES.last
			return nil if res.body.empty?
			raise "Requires format parameter" if !params[:format]
			case params[:format]
			when "json"
				MultiJson.load(res.body)
			else
				res
			end
		end

		private

		def http_get(uri, params = {}, access_token = nil)
			http_call(:get, uri, params, access_token)
		end

		def http_delete(uri, params = {} , access_token = nil)
			http_call(:delete, uri, params, access_token)
		end

		def http_call(verb, uri, params = {}, access_token = nil)
			headers = { "Accept" => "application/json" }.merge(@headers)
			headers["Authorization"] = "Bearer #{access_token}" if access_token
			self.class.send(verb, uri.to_s, headers: headers, query: params)
			#File.open("last_response_get.html", "w") { |f| f.write(HttpCapture::RESPONSES.last.body) }
			HttpCapture::RESPONSES.last
		end

		def http_patch(uri, body_params, access_token = nil)
			http_send(:patch, uri, body_params, access_token)
		end

		def http_post(uri, body_params, access_token = nil)
			http_send(:post, uri, body_params, access_token)
		end

		def http_send(verb, uri, body_params, access_token = nil)
			headers = { "Accept" => "application/json", "Content-Type" => "application/x-www-form-urlencoded" }.merge(@headers)
			headers["Authorization"] = "Bearer #{access_token}" if access_token
			body_params.reject! { |k, v| v.nil? }
			body_params = URI.encode_www_form(body_params) unless body_params.is_a?(String)
			self.class.send(verb, uri.to_s, headers: headers, body: body_params)
			#File.open("last_response_send.html", "w") { |f| f.write(HttpCapture::RESPONSES.last.body) }
			HttpCapture::RESPONSES.last
		end
	end
end
