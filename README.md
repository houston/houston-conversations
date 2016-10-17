# Houston::Conversations

Conversations allows Houston to interact as a Chatbot through a variety of mediums.


## Usage

You prepare Houston to communicate by creating **listeners**. There are two methods for creating a listener, `listen_for` and `overhear`. `listen_for` will match messages only if they are directed to Houston (i.e. the person sending message mentioned Houston by name or the person is direct-messaging or texting Houston). `overhear` will match against any message that Houston can hear.

```ruby
Houston::Conversations.config do

  # Houston will say "hello" to anyone who says "hello" to it.
  # This listener and reply will work with any adapter.
  listen_for("hello") do |e|
    e.reply "hello"
  end

  # Houston will tell a joke if it hears anyone say "ouch".
  # This listener will only match messages that are heard in Slack;
  # and it responds with a Slack-specific image attachment.
  overhear "ouch", context: :slack do |e|
    e.reply "",
      attachments: [{
        fallback: "On a scale of 1 to 10, how would you rate your pain?",
        image_url: "https://s-media-cache-ak0.pinimg.com/736x/6d/17/5f/6d175f5daa186a3cd4d2a007e26a90ab.jpg"
      }]
  end

end
```

Houston::Conversations uses a library called Attentive to figure out if a message from a person matches one if its listeners. To learn more about listeners, see [Attentive's README](https://github.com/houston/attentive#attentive).


## Adapters

While Houston::Conversations provides the DSL for setting up listeners, it doesn't integrate directly with the contexts where Houston could be listening for messages — like Slack, SMS, or Speech-to-Text software.

Houston has adapters for chatting through [Slack](https://github.com/houston/houston-slack#houstonslack) and texting through [Twilio](https://github.com/houston/houston-twilio#houstontwilio).

It's fairly simple to write a new adapter to allow Houston to chat through other media. See [Writing an Adapter](https://github.com/houston/houston-conversations/blob/master/docs/writing-an-adapter.md#writing-an-adapter).


## Installation

You'll generally not include Houston::Conversations directly in your `Gemfile`, or add the typical `use :conversations` statement to your `config/main.rb`. Houston::Conversations will be a dependency of whichever adapter(s) you include. To start using conversations via Slack, for example, you'll add the following to your `Gemfile`:

    gem "houston-slack", github: "houston/houston-slack", branch: "master"

And in `config/main.rb`, add:

```ruby
use :slack do
  token ENV["HOUSTON_SLACK_TOKEN"]
end
```

And then execute:

    $ bundle


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
