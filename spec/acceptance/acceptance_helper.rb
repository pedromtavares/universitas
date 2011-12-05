require File.dirname(__FILE__) + "/../spec_helper"
require "steak"
require 'capybara/rails'

RSpec.configuration.include Capybara::DSL, :type => :acceptance

# Put your acceptance spec helpers inside /spec/acceptance/support
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

module Rack
  module Utils
    def escape(s)
      CGI.escape(s.to_s)
    end
    def unescape(s)
      CGI.unescape(s)
    end
  end
end