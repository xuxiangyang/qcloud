require 'digest'
require 'openssl'
require 'net/http'
require 'net/https'
module Qcloud
  class Service
    attr_accessor :host, :region, :secret_id, :secret_key, :http
    def initialize(host, region, secret_id, secret_key)
      @host = host
      @region = region
      @secret_id = secret_id
      @secret_key = secret_key
      @http = Net::HTTP.new(host, 443)
      @http.use_ssl = true
    end

    def post(action, version, params = {}, headers = {})
      headers["Host"] ||= host
      headers["Content-Type"] = "application/json; charset=utf-8"
      headers["X-TC-Action"] ||= action
      headers["X-TC-Region"] ||= region
      headers["X-TC-Timestamp"] ||= Time.now.to_i.to_s
      headers["X-TC-Version"] ||= version

      body = JSON.dump(params)
      signed_headers = "content-type;host"
      canonical_headers = "content-type:application/json; charset=utf-8\nhost:#{headers['Host'].downcase}\n"
      hashed_request_payload = Digest::SHA256.hexdigest(body).downcase
      canonical_request = "POST\n/\n\n#{canonical_headers}\n#{signed_headers}\n#{hashed_request_payload}"
      date = Time.now.utc.strftime('%Y-%m-%d')
      service = host.split('.').first
      string_to_sign = "TC3-HMAC-SHA256\n#{headers['X-TC-Timestamp']}\n#{date}/#{service}/tc3_request\n#{Digest::SHA256.hexdigest(canonical_request).downcase}"
      secret_date = OpenSSL::HMAC.digest("SHA256", "TC3#{secret_key}", date)
      secret_service = OpenSSL::HMAC.digest("SHA256", secret_date, service)
      secret_signing = OpenSSL::HMAC.digest("SHA256", secret_service, "tc3_request")
      signature = OpenSSL::HMAC.hexdigest("SHA256", secret_signing, string_to_sign)
      headers["Authorization"] = "TC3-HMAC-SHA256 Credential=#{secret_id}/#{date}/#{service}/tc3_request, SignedHeaders=#{signed_headers}, Signature=#{signature}"

      req = Net::HTTP::Post.new("/", headers)
      req.body = body
      http.request(req)
    end
  end
end
