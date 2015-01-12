require "base64" # gem: rubysl-base64
require "openssl"
require "securerandom"

module BraintreeEncryption
  def self.encrypt(value, public_key)
    # reverse engineered from https://github.com/braintree/braintree.js/blob/master/lib/braintree.js
    # this may need to be updated if braintree change their client-side encryption scripts

    return nil if value.nil?
    return "" if value.respond_to?(:empty?) && value.empty?

    raise "The Braintree client key is not configured" if public_key.nil?
    raw_key = Base64.strict_decode64(public_key)
    rsa = OpenSSL::PKey::RSA.new(raw_key)

    aes = OpenSSL::Cipher::AES256.new(:CBC).encrypt
    aes_key, aes_iv = aes.random_key, aes.random_iv
    encrypted_value = aes.update(value.to_s) + aes.final
    ciphertext = aes_iv + encrypted_value
    encoded_ciphertext = Base64.strict_encode64(ciphertext)

    hmac_key = SecureRandom.random_bytes(32)
    hmac = OpenSSL::HMAC.digest(OpenSSL::Digest::SHA256.new, hmac_key, ciphertext)
    signature = Base64.strict_encode64(hmac)

    combined_key = aes_key + hmac_key
    encoded_key = Base64.strict_encode64(combined_key)
    encrypted_key = Base64.strict_encode64(rsa.public_encrypt(encoded_key))

    "$bt4|javascript_1_3_9$#{encrypted_key}$#{encoded_ciphertext}$#{signature}"
  end
end