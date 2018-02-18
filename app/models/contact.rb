class Contact < ActiveRecord::Base
  attr_accessor :phone_number
  has_many :phone_numbers, dependent: :destroy
  belongs_to :user


  after_find :get_phone_number
  after_save :save_phone_numbers

  validates :email, presence: true, format: Devise.email_regexp
  validates_presence_of :name, :address,:phone_number
  validate :phone_number_value

  include PgSearch

  pg_search_scope :search, against:[:name,:email,:address],
  :using => {:tsearch => {:prefix => true}},
  :ignoring => :accents,  
  associated_against: {phone_numbers: :number}
  
  # def self.search(query)
  #   if query.present?
  #     search_by_name(query)
  #   else
  #     # No query? Return all records, newest first.
  #     search_by_name('%')
  #   end
  # end

  def phone_number_value
    numbers_array = self.phone_number.split(",")
    numbers_array.each do |nn|      
      if nn.to_i.to_s.length != 10
        self.errors[:phone_number]<< "must be 10 digit number"
      end      
    end
  end

  def get_phone_number
    numbers = self.phone_numbers
    self.phone_number = ""
    numbers.each do |nn|
      self.phone_number+= "#{nn.number},"
    end 
    self.phone_number = self.phone_number[0..-2]
  end

  def self.to_csv
    attributes = %w{id name email phone_number address }

    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.each do |contact|
        csv << attributes.map{ |attr| contact.send(attr) }
      end
    end
  end  

    def save_phone_numbers
      numbers_array = self.phone_number.split(",")
      self.phone_numbers.destroy_all
      numbers_array.each do |n|
       new_number = PhoneNumber.new(contact_id: id, number: n)
       new_number.save()
      end
    end



    # def self.text_search(query)
    #   if query.present?
    #     rank = <<-RANK
    #   ts_rank(to_tsvector(name), plainto_tsquery(#{sanitize(query)})) +
    #   ts_rank(to_tsvector(email), plainto_tsquery(#{sanitize(query)})) +
    #   ts_rank(to_tsvector(address), plainto_tsquery(#{sanitize(query)})) + 
    #   ts_rank(to_tsvector(number), plainto_tsquery(#{sanitize(query)})) 
      

    # RANK
    # where("to_tsvector('english', name) @@ :q or to_tsvector('english', email) @@ :q or to_tsvector('english', address) @@ :q or to_tsvector('english', number) @@ :q", q: query).order("#{rank} desc")
    #   else
    #      where(nil)
    #   end
    # end
end
