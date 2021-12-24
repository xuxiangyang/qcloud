require 'active_support/all'
require "qcloud/version"
require 'qcloud/service'
require 'qcloud/live'
require 'qcloud/vod'
require 'json'

module Qcloud
  class Error < StandardError; end

  class JsonParseError < Error
    def initialize(message, body)
      @body = body
      super(message)
    end

    def raven_context
      { body: @body }
    end
  end
end
