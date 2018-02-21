class ContactsController < ApplicationController
  before_action :authenticate_user!
 
  layout 'contact'
  def new 
      
  end

  def create    
    
    contact = current_user.contacts.new(contact_params)
     
    if contact.save
      flash[:notice]=" Contact created successfully"
      redirect_to contacts_path
    else
      flash[:alert]= contact.errors.full_messages
      render 'new'
    end
  end

  def index
    if params[:query].present?
      @contacts = current_user.contacts.search(params[:query]).page(params[:page]).per_page(3)
    else
      @contacts = current_user.contacts.page(params[:page]).per_page(3)
    end  
    respond_to do |format|
      format.html
      format.csv { send_data @contacts.to_csv}
    end
  end

  def show
    @contact = Contact.find_by_id(params[:id])
    @phone_numbers= @contact.phone_numbers
  end

  def edit
    # byebug
    @contact = Contact.find_by_id(params[:id])
    # @phone_numbers = @contact.phone_numbers
  end

  def update

    @contact = Contact.find_by_id(params[:id])
    if @contact.update_attributes(contact_params)
      flash[:notice]=" Contact updated successfully"
      redirect_to contacts_path
    else
      flash[:alert]= @contact.errors.full_messages
      redirect_to edit_contact_path
    end
    
  end

  def destroy
    Contact.find_by_id(params[:id]).destroy
    flash[:notice]=" Contact dated successfully"
    redirect_to contacts_path
  end

  def download
    @contacts = request.env['omnicontacts.contacts']
    count = 0
     # byebug
    if @contacts.present? 
      @contacts.each do |contact|
        # byebug
        # if contact.present?
        #  byebug
        # end 
        contact = current_user.contacts.new(name: contact[:name], address: contact[:addresses], email: contact[:email], phone_number: contact[:phone_numbers].map{|y| y[:number]}.join(","))
        if contact.save
          count +=1
        end
      end
      flash[:notice]= "#{count} Contact created successfully"
      redirect_to contacts_path
    else
      flash[:notice]= " unable to import contacts"
      redirect_to contacts_path
    end

    # respond_to do |format|
    #   format.html
    # end
  end

  private

    def contact_params
      params.require(:contact).permit(:name, :email, :address, :phone_number)
    end


end