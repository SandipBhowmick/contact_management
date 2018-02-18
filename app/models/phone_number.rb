class PhoneNumber < ActiveRecord::Base
  belongs_to :contact
  validates_presence_of :contact_id, :number
  validates_numericality_of :number
  
end
