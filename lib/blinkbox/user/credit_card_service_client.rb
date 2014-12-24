require 'httparty'
require 'multi_json'
require 'net/http/capture'

module Blinkbox
  class CreditCardServiceClient
    include HTTParty
    attr_accessor :headers

    def initialize(server_uri, proxy_uri = nil)
      self.class.base_uri(server_uri.to_s)
      self.class.http_proxy(proxy_uri.host, proxy_uri.port, proxy_uri.user, proxy_uri.password) if proxy_uri
      self.class.debug_output($stderr) if ENV['DEBUG']
      @headers = {}
    end

    def use_proxy(proxy_uri)
      proxy_uri = URI.parse(proxy_uri) if proxy_uri.is_a?(String)
      self.class.http_proxy(proxy_uri.host, proxy_uri.port, proxy_uri.user, proxy_uri.password)
    end

    def add_credit_card(access_token, card_details = {})
      body = {
          default: card_details[:default],
          number: card_details[:cc_number],
          cvv: card_details[:cvv],
          expirationMonth: card_details[:expiration_month],
          expirationYear: card_details[:expiration_year],
          cardholderName: card_details[:card_holder_name],
          billingAddress: card_details[:billing_address]
      }

      response = http_post "/service/my/creditcards", body, access_token
      card_id = MultiJson.load(response.body)['id']

      card_id
    end

    private

    def http_post(uri, body, access_token = nil)
      http_send(:post, uri, body, access_token)
    end

    def http_send(verb, uri, post_body, access_token = nil)
      headers = {"Content-Type" => "application/vnd.blinkboxbooks.data.v1+json" }.merge(@headers)
      headers["Authorization"] = "Bearer #{access_token}" if access_token
       self.class.send(verb, uri.to_s, headers: headers, body: post_body.to_json)
      HttpCapture::RESPONSES.last
    end
  end
end
