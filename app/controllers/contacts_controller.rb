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

  private

    def contact_params
      params.require(:contact).permit(:name, :email, :address, :phone_number)
    end


end