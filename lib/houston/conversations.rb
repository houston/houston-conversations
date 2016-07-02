require "houston/conversations/engine"
require "houston/conversations/configuration"

module Houston
  module Conversations
    extend self

    def config(&block)
      @configuration ||= Conversations::Configuration.new
      @configuration.instance_eval(&block) if block_given?
      @configuration
    end

  end
end
