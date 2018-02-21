require "omnicontacts"

Rails.application.middleware.use OmniContacts::Builder do
  importer :gmail, "179124996790-d513c0dvfh6lo3s6945eotrq8fuqen4f.apps.googleusercontent.com", "6XKpUpUCy0otyScBz-KAA0z4", {:redirect_path => "/contacts/gmail/contact_callback"}
end