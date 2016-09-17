require "attentive/listener"

module Houston
  module Conversations
    class Listener < Attentive::Listener
      attr_accessor :conversation

      def matches_context?(message)
        contexts = message.contexts.dup
        contexts << :conversation if conversation && conversation.includes?(message)

        return false unless contexts.superset? @required_contexts
        return false unless contexts.disjoint? @prohibited_contexts
        true
      end

      def call_async(event)
        Rails.logger.debug "\e[35m[conversations:hear] #{event.message}\e[0m"

        Houston.async do
          begin
            call(event)
          rescue Exception # rescues StandardError by default; but we want to rescue and report all errors
            Houston.report_exception $!, parameters: event.to_h
            Rails.logger.error "\e[31m[conversations:hear] (#{$!.class}) #{$!.message}\n  #{$!.backtrace.join("\n  ")}\e[0m"
            event.reply "An error occurred when I was trying to answer you"
          end
        end
      end

    end
  end
end
