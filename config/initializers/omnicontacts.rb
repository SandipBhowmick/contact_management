require "omnicontacts"

Rails.application.middleware.use OmniContacts::Builder do
  importer :gmail, "", "", {:redirect_path => "/contacts/gmail/contact_callback"}
end
