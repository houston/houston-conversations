require "houston/conversations/engine"
require "houston/conversations/configuration"
require "houston/conversations/listener_collection"
require "houston/conversations/event"

module Houston
  module Conversations
    extend self

    def config(&block)
      @configuration ||= Conversations::Configuration.new
      @configuration.instance_eval(&block) if block_given?
      @configuration
    end

    def listeners
      @listeners ||= Houston::Conversations::ListenerCollection.new
    end

    def wake_words
      Attentive.invocations
    end

    def wake_words=(value)
      Attentive.invocations = value
    end

    # Matches a message against all listeners
    # and invokes the first listener that mathes
    def hear(message, params={})
      raise ArgumentError, "`message` must respond to :channel" unless message.respond_to?(:channel)
      raise ArgumentError, "`message` must respond to :sender" unless message.respond_to?(:sender)

      listeners.hear(message).each do |match|
        event = Houston::Conversations::Event.new(match)

        if block_given?
          yield event, match.listener
        else
          match.listener.call_async event
        end

        # Invoke only one listener per message
        return true
      end

      false
    end

  end
end
