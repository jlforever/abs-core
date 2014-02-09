class RegistrationsController < ApplicationController
  
  before_filter :build_form_required_values, :only => [:create, :new]
  before_filter :acquire_registration_headers
  
  def acquire_registration_headers
    result = ::Registration::FileHelpers.parse_reg_page_headers
    @intro_texts = result["header"]
    @date_time = result["date_time"]
  end
  
  def build_form_required_values
    @class_levels = { 
      "Panda Group (Ages 3 - 6)" => "Panda Group (Ages 3 - 6)", 
      "Star Group (Ages 6 - 10)" => "Star Group (Ages 6 - 10)" 
    }
    @hear_about_us_options = [
      ["Website", "Website"], 
      ["Flyer", "Flyer"], 
      ["Advertisment", "Advertisment"], 
      ["Friends", "Friends"], 
      ["Others", "Others"]]
      
    @locations_options = [
      'Boston - Brimmer St.',
      'Braintree - Dobson Rd.'
    ]
  end
  
  def index
    @registration_form_link ||= ::Registration::FileHelpers.url_for_registration_form 
    @free_class_registration_form_link ||= ::Registration::FileHelpers.url_for_free_class_registration_form
  end
  
  def new
    @registration = Registration.new
  end
  
  def create
    @registration = Registration.new(params['registration'])
    begin
      if @registration.save!
        @message = "Thank you for registering with Alpha Beta Language School!"
        @registration_email = @registration.parent_email
      end
    rescue => ex
      render :action => :new
    end
  end

end