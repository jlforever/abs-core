class RegistrationsController < ApplicationController
  
  def index
    @registration_form_link ||= ::Registration::FileHelpers.url_for_registration_form 
    @free_class_registration_form_link ||= ::Registration::FileHelpers.url_for_free_class_registration_form
    result = ::Registration::FileHelpers.parse_reg_page_headers
    @intro_texts = result["header"]
    @date_time = result["date_time"]
  end
  
  def new
    @class_levels = { 
      "Beginner Panda Group" => "(Ages 3 - 5)", 
      "Beginner Star Group" => "(Ages 5 - 10)" 
    }
    @hear_about_us_options = ["Website", "Flyer", "Advertisment", "Friends", "Others"]
    @registration = Registration.new
    @default_start_year = 1980
  end
  
  def create
    @message = "Hello world"
  end

end