class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :loading_menu_options
  
  def loading_menu_options
    @menu_options ||= ["HOME", "PROGRAMS", "REGISTRATION", "TESTIMONIAL", "CONTACT US"]
  end

end
