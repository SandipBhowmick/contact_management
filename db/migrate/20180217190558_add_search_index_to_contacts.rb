class AddSearchIndexToContacts < ActiveRecord::Migration
  def up
    execute "create index contacts_name on contacts using gin(to_tsvector('english', name))"
    execute "create index contacts_email on contacts using gin(to_tsvector('english', email))"
    execute "create index contacts_address on contacts using gin(to_tsvector('english', address))"
  end

  def down
    execute "drop index contacts_name"
    execute "drop index contacts_email"
    execute "drop index contacts_address"
  end
end
