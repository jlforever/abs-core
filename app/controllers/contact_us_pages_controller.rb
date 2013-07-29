class ContactUsPagesController < ApplicationController
  
  def new
    @interests = ["Enrollment", "Free Class", "General Information"]
    @lang_of_interest = ["Chinese Mandarin", "Others"]
  end
  
  def presence_of_all_required_fields?(hash)
    ["parent_first_name", "parent_last_name", "phone_number", "email_address"].all? do |field|
      hash[field].present?
    end
  end
  
  def create
    # detect whether all of the required fields are present
    @valid = presence_of_all_required_fields?(params)
    
    # only send notification of contact us email when 
    # all of the required fields are appearing in the 
    # params list
    if @valid
      Notifier.contact_us_email(params).deliver
    else
      flash[:flash_alert] = "Not all of the required fields are filled in!"
      redirect_to new_contact_us_page_path
    end
  end
  
end