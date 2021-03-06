require "concurrent/array"

module Houston
  module Conversations
    class Conversation

      def initialize(channel, sender)
        @channel = channel
        @sender = sender
        @listeners = Concurrent::Array.new
      end

      def listen_for(*args, &block)
        Houston::Conversations.listeners.listen_for(*args, &block).tap do |listener|
          listener.conversation = self
          listeners.push listener
        end
      end

      def includes?(message)
        message.channel == channel && message.sender == sender
      end

      def reply(*messages)
        channel.reply(*messages)
      end
      alias :say :reply

      def ask(question, expect: nil)
        listen_for(*Array(expect)) do |e|
          e.stop_listening!
          yield e
        end

        reply question
      end

      def end!
        listeners.each(&:stop_listening!)
      end

    private
      attr_reader :channel, :sender, :listeners

    end
  end
end
