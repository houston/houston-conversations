# Load Houston
require "houston/application"

# Configure Houston
Houston.config do

  # Houston should load config/database.yml from this module
  # rather than from Houston Core.
  root Pathname.new File.expand_path("../../..",  __FILE__)

  # Give dummy values to these required fields.
  host "houston.test.com"
  secret_key_base "2d1ab83477af2a340e48600c4550ed"
  mailer_sender "houston@test.com"

  # Mount this module on the dummy Houston application.
  use :conversations

end
