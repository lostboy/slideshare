require "rubygems"
require "httparty"
require "curb"

require "slide_share/errors"
require "slide_share/base"
require "slide_share/slideshows"

unless Array.new.respond_to?(:extract_options!)
  # Via ActiveSupport
  class Array
    def extract_options!
      last.is_a?(Hash) ? pop : {}
    end
  end
end