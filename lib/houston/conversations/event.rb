require "houston/conversations/conversation"

module Houston
  module Conversations
    class Event
      attr_reader :match

      def initialize(match)
        @match = match
      end



      def message
        match.message
      end

      def channel
        message.channel
      end

      def sender
        message.sender
      end

      def user
        sender.user
      end



      def matched?(key)
        match.matched?(key)
      end

      def stop_listening!
        match.listener.stop_listening!
      end

      def responding
        # do nothing; specific backends can implement the appropriate action
      end

      def reply(*args)
        channel.reply(*args)
      end

      def random_reply(replies)
        if replies.is_a?(Hash)
          weights = replies.values
          unless weights.reduce(&:+) == 1.0
            raise ArgumentError, "Reply weights don't add up to 1.0"
          end

          draw = rand
          sum = 0
          pick = nil
          replies.each do |reply, weight|
            pick = reply unless sum > draw
            sum += weight
          end
          reply pick
        else
          reply replies.sample
        end
      end

      def start_conversation!
        Conversation.new(channel, sender)
      end



      def to_h
        { channel: channel, message: message, sender: sender }
      end

    end
  end
end
