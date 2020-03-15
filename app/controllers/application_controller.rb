class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :loading_menu_options
  before_filter :load_connections_links
  
  def load_connections_links
    @facebook_link = "https://www.facebook.com/Alpha-Beta-Language-School-101542811473647"
    @twitter_link = "https://twitter.com/ABLS3"
    @youtube_link = "http://www.youtube.com/channel/UCzEufCsJkU6JbB4WrtADSsQ"
  end
  
  def loading_menu_options
    @menu_options ||= { 
      "HOME" => root_path,
      "PROGRAMS" => program_pages_path,
      "REGISTRATION" => new_registration_path,
      "TESTIMONIALS" => testimonials_path,
      "CONTACT US" => new_contact_us_page_path
    }
    @quick_links ||= { 
      "Homepage" => root_path, 
      "Contact Us" => new_contact_us_page_path, 
      "Sitemap" => "#", 
      "Privacy Policy" => "#", 
      "Term of Use" => "#", 
    }
  end

end
