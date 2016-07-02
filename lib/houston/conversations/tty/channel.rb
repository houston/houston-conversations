module Houston
  module Conversations
    module Tty
      class Channel
        attr_reader :session

        def initialize(session)
          @session = session
        end

        def reply(message)
          session.say message
        end

      end
    end
  end
end
