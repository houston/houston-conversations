require "houston/conversations/tty/message"
require "etc"

module Houston
  module Conversations
    class TtySession

      def initialize(input=STDIN, output=STDOUT)
        @input = input
        @output = output
        @prompt = "#{Etc.getlogin}> "
      end

      def listen!
        output.print prompt
        while text = input.gets
          message = Houston::Conversations::Tty::Message.new(self, text)
          unless Houston::Conversations.hear(message)
            output.print prompt
          end
        end
      end

      def say(message)
        output.puts "houston> #{message}"
        output.print prompt
      end

    private
      attr_reader :input, :output, :prompt
    end
  end
end
