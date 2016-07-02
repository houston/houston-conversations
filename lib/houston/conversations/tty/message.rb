require "houston/conversations/message"
require "houston/conversations/tty/channel"
require "houston/conversations/tty/user"

module Houston
  module Conversations
    module Tty
      class Message < ::Houston::Conversations::Message
        attr_reader :session

        def initialize(session, text, params={})
          @session = session
          super text, params
          contexts << :conversation
          contexts << :tty
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
