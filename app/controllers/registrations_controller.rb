class RegistrationsController < ApplicationController
  
  before_filter :build_form_required_values, :only => [:create, :new]
  
  def build_form_required_values
    @class_levels = { 
      "Beginner Panda Group" => "(Ages 3 - 5)", 
      "Beginner Star Group" => "(Ages 5 - 10)" 
    }
    @hear_about_us_options = [
      ["Website", "Website"], 
      ["Flyer", "Flyer"], 
      ["Advertisment", "Advertisment"], 
      ["Friends", "Friends"], 
      ["Others", "Others"]]
  end
  
  def index
    @registration_form_link ||= ::Registration::FileHelpers.url_for_registration_form 
    @free_class_registration_form_link ||= ::Registration::FileHelpers.url_for_free_class_registration_form
    result = ::Registration::FileHelpers.parse_reg_page_headers
    @intro_texts = result["header"]
    @date_time = result["date_time"]
  end
  
  def new
    @registration = Registration.new
  end
  
  def create
    @registration = Registration.new(params['registration'])
    begin
      if @registration.save!
        @message = "Hello world"
      end
    rescue => ex
      render :action => :new
    end
  end

end