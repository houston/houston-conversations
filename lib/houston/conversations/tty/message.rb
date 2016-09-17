require "houston/conversations/tty/channel"
require "houston/conversations/tty/user"

module Houston
  module Conversations
    module Tty
      class Message
        attr_reader :session, :text

        def initialize(session, text)
          @session = session
          @text = text
        end

        alias :to_s :text

        def contexts
          [ :conversation, :tty ]
        end

        def channel
          Houston::Conversations::Tty::Channel.new(session)
        end

        def sender
          Houston::Conversations::Tty::User.new(session)
        end

      end
    end
  end
end
