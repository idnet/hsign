require 'openssl'
require 'rack/utils'
require 'hsign/extensions'

module HSign
  class Digest
    attr_accessor :hmac_key
    attr_reader :params

    def initialize(secret, salt = nil)
      @digest = OpenSSL::Digest.new('sha1')
      @hmac_key = '_hmac'
      @secret = secret
      @salt = salt
    end

    def sign(request_params)
      hmac = OpenSSL::HMAC.new @secret, @digest
      hmac << @salt if @salt
      # Normalize all params
      @params = Rack::Utils.parse_query(Rack::Utils.build_nested_query(request_params.to_hsign_string_values))
      @params.delete(hmac_key)

      @params.to_a.sort_by{|k,v| k.to_s}.each do |k,v|
        hmac << "#{k}=#{v}"
      end

      @params[hmac_key] =  hmac.hexdigest
    end

    def verify?(params)
      expected = params.delete(hmac_key)
      expected == sign(params)
    end

    def each_param &block
      return false unless @params
      @params.each(&block)
    end

  end
end
