# Writing an Adapter

Houston has adapters for chatting through [Slack](https://github.com/houston/houston-slack#houstonslack) and texting through [Twilio](https://github.com/houston/houston-twilio#houstontwilio); but it can easily be extended to allow Houston to communicate through other platforms.

### Hear

Whenever you receive a message via the new service, pass an object representing the message to `Houston::Conversations.hear`. Your message object should respond to:

  1. `to_s` — with the text of the message
  2. `channel` — with an object that represents where the message was heard; `channel` should respond to `reply` and provide a way for Houston to communicate back to the user.
  3. `sender` — with an object identifying the sender of the message

Your message object may also respond to `contexts` and return an array of symbols describing the contexts where the message was heard.

### Example

Here's a very simple client that would you let converse with Houston from the commandline:

```ruby
class TtyChannel
  def initialize(session)
    @session = session
  end

  def reply(message, *args)
    @session.say message
  end
end

class TtyMessage
  def initialize(session, text)
    @session = session
    @text = text
  end

  def to_s
    @text
  end

  def contexts
    [ :conversation, :tty ]
  end

  def channel
    TtyChannel.new(@session)
  end

  def sender
  end
end

class TtySession
  def listen!
    print prompt
    while text = gets
      message = TtyMessage.new(self, text)
      unless Houston::Conversations.hear(message)
        print prompt
      end
    end
  end

  def say(message)
    puts "houston >  #{message}"
    print prompt
  end

  def prompt
    "#{Etc.getlogin} >  "
  end
end

TtySession.new.listen!
```
