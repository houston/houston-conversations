require "houston/conversations/engine"
require "houston/conversations/configuration"
require "houston/conversations/listener_collection"
require "houston/conversations/message"
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

    # Matches a message against all listeners
    # and invokes the first listener that mathes
    def hear(message, params={})
      raise ArgumentError, "`message` is a #{message.class.name} but must be a subclass of Houston::Conversations::Message" unless message.is_a?(Houston::Conversations::Message)

      listeners.hear(message).each do |match|

        event = Houston::Conversations::Event.new(match)
        yield event if block_given?
        invoke! match.listener, event

        # Invoke only one listener per message
        return true
      end

      false
    end

  private

    def invoke!(listener, event)
      Rails.logger.debug "\e[35m[conversations:hear] #{event.message}\e[0m"

      Houston.async do
        begin
          listener.call(event)
        rescue Exception # rescues StandardError by default; but we want to rescue and report all errors
          Houston.report_exception $!, parameters: event.to_h
          Rails.logger.error "\e[31m[conversations:exception] (#{$!.class}) #{$!.message}\n  #{$!.backtrace.join("\n  ")}\e[0m"
          event.reply "An error occurred when I was trying to answer you"
        end
      end
    end

  end
end
