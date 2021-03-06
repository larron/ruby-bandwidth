require 'minitest/autorun'
require 'minitest/pride'

require_relative '../lib/bandwidth.rb'

module Bandwidth
  class StubbedConnection < Connection
    def http
      @http ||= StubbedHttp.new @user_id, @token, @secret
    end

    alias :short_http :http

    delegate :stub, to: :http

    class StubbedHttp < HTTP
      def connection
        @connection ||= Faraday.new do |faraday|
          faraday.adapter :test, @stubs
          faraday.basic_auth @token, @secret
        end
      end

      def url path
        path
      end

      def stub
        @stubs ||= Faraday::Adapter::Test::Stubs.new
      end
    end
  end
end
