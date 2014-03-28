require 'rubygems'
require 'bundler'
require 'constantcontact'
require 'pry'
require 'fakeredis/rspec'
# require 'hammertime19'
# require 'ruby-debug'

Bundler.setup

# add spec folder to load path
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__)))

# add lib to load path
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), "..", "lib"))

# add fixtures to load path
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), "fixtures"))

require 'locomotivecms-liquid'

require 'rspec'

RSpec.configure do |config|
  config.mock_framework = :rspec
  config.order = :random
end

# add support to load path
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), "support"))

# load support helpers
Dir["#{File.dirname(__FILE__)}/support/**/*.rb", File.join(File.dirname(__FILE__), "..", "lib", "*.rb")].each {|f| require f}

# Liquid Helpers for use within specs
module Liquid
  module SpecHelpers

    # shortcut to render a template
    def render(body, *args)
      body = eval(subject) if body == :subject
      Liquid::Template.parse(body).render(*args)
    end

    def render!(body, *args)
      body = eval(subject) if body == :subject
      Liquid::Template.parse(body).render!(*args)
    end

    # shortcut to parse a template
    def parse(body = nil)
      body = eval(subject) if body == :subject
      Liquid::Template.parse(body)
    end

    # helper to output a node's information
    def print_child(node, depth = 0)
      information = (case node
        when Liquid::InheritedBlock
          "Liquid::InheritedBlock #{node.object_id} / #{node.name} / #{!node.parent.nil?} / #{node.nodelist.first.inspect}"
      else
        node.class.name
      end)

      # puts information.insert(0, ' ' * (depth * 2))
      if node.respond_to?(:nodelist)
        node.nodelist.each do |node|
          print_child node, depth + 1
        end
      end
    end
  end
end

RSpec.configure do |c|
  c.include Liquid::SpecHelpers
end

ENV['cc_api_key']       = 'qg5g5x7m67phshzwx3fhj9d3'
ENV['cc_api_secret']    = 'ZCJPysEUKMSNuNv7dGpJDCm9'
ENV['cc_redirect_uri']  = 'http://localhost:8080'