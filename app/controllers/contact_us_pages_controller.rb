class ContactUsPagesController < ApplicationController
  
  def new
    @interests = ["Enrollment", "Free Class", "General Information"]
    @lang_of_interest = ["Chinese Mandarin", "Spanish", "Others"]
    @metro_areas = [
      ['Select a study location', nil],
      ['Virtual class', 'Virtual class'],
      ['Boston/Cambridge', 'Boston/Cambridge'], 
      ['Metro West', 'Metro West'], 
      ['North Shore', 'North Shore'], 
      ['South Shore', 'South Shore'], 
      ['Others', 'Others'],
    ]
  end
  
  def presence_of_all_required_fields?(hash)
    ["parent_first_name", "parent_last_name", "phone_number", "email_address", "metro_area"].all? do |field|
      hash[field].present?
    end
  end
  
  def email_format_correct?(email)
    email.match(/\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i).to_s.present?
  end
  
  def create
    # detect whether all of the required fields are present
    @valid = presence_of_all_required_fields?(params)
    
    # only send notification of contact us email when 
    # all of the required fields are appearing in the 
    # params list
    if @valid
      if email_format_correct?(params['email_address'])
        Notifier.contact_us_email(params).deliver
      else
        flash[:flash_alert] = "Incorrect email format!"
        redirect_to new_contact_us_page_path
      end
    else
      flash[:flash_alert] = "Please fill in all of the required fields!"
      redirect_to new_contact_us_page_path
    end
  end
  
end