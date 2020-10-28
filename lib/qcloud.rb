require 'active_support/all'
require "qcloud/version"
require 'qcloud/service'
require 'qcloud/live'
require 'qcloud/vod'
require 'json'

module Qcloud
  class Error < StandardError; end
end
