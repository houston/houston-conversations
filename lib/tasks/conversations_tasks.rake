require "houston/conversations/tty/session"

desc "Test conversations with Houston"
task :talk => :environment do
  Houston::Conversations::Tty::Session.new.listen!
end
