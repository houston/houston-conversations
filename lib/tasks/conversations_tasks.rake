require "houston/conversations/tty_session"

desc "Test conversations with Houston"
task :talk => :environment do
  Houston::Conversations::TtySession.new.listen!
end
