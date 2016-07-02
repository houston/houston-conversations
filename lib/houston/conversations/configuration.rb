module Houston::Conversations
  class Configuration


    def listen_for(*args, &block)
      Houston::Conversations.listeners.listen_for(*args, &block)
    end

    def overhear(*args, &block)
      Houston::Conversations.listeners.overhear(*args, &block)
    end

  end
end
