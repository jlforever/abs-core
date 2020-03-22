class RegistrationsController < ApplicationController
  
  before_filter :build_form_required_values, :only => [:create, :new]
  before_filter :acquire_registration_headers
  
  def acquire_registration_headers
    result = ::Registration::FileHelpers.parse_reg_page_headers
    @intro_texts = result["header"]
    h = { 'boston' => [], 'braintree' => [], 'virtual' => [] }
    @date_time = result["date_time"].reduce(h) do |hash, dt|
      if dt.match(/boston/i).present? 
        hash['boston'] << dt.gsub(/\sBoston\s?/i, " ").strip
      elsif dt.match(/braintree/).present?
        hash['braintree'] << dt.gsub(/\sBraintree\s?/i, " ").strip
      elsif dt.match(/Zoom/).present?
        hash['virtual'] << dt.gsub(/\sZoom\s?/i, " ").strip
      end
      hash
    end
  end
  
  def build_form_required_values
    @class_levels = {
      # Panda and Star groups temp unavailable
      #"Panda Group (Ages 3 - 6)" => "Panda Group (Ages 3 - 6)", 
      #"Star Group (Ages 6 - 10)" => "Star Group (Ages 6 - 10)",
      'Virtual Class (Ages 4 - 6)' => 'Virtual Class (Ages 4 - 6)'
    }
    @hear_about_us_options = [
      ["Website", "Website"], 
      ["WeChat Group", "WeChat Group"],
      ["Flyer", "Flyer"], 
      ["Advertisment", "Advertisment"], 
      ["Friends", "Friends"], 
      ["Others", "Others"]]
      
    @locations_options = [
      # No physical location face to face teaching at the moment
      #'Boston - Brimmer St.',
      #'Braintree - Dobson Rd.'
      'Virtual Class - Via Zoom'
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
      if ex.message.match(/at least 3 years old/) || ex.message.match(/either skip the second child/)
        flash.now[:flash_alert] = ex.message.gsub('Validation failed:', '').strip
      end
      render :action => :new
    end
  end

end