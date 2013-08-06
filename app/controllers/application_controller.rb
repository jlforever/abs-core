class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :loading_menu_options
  
  def loading_menu_options
    @menu_options ||= { 
      "HOME" => root_path,
      "PROGRAMS" => program_pages_path,
      "REGISTRATION" => registrations_path,
      "TESTIMONIAL" => "#",
      "CONTACT US" => new_contact_us_page_path
    }
    @quick_links ||= { 
      "Homepage" => root_path, 
      "Contact Us" => new_contact_us_page_path, 
      "Sitemap" => "#", 
      "Privacy Policy" => "#", 
      "Term of Use" => "#", 
      "Copyright Information" => "#"
    }
  end

end
