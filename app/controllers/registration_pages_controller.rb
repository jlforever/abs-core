class RegistrationPagesController < ApplicationController
  
  def index
    @registration_form_link ||= ::Registration::FileHelpers.url_for_registration_form 
    @free_class_registration_form_link ||= ::Registration::FileHelpers.url_for_free_class_registration_form
    @intro_texts = ::Registration::FileHelpers.parse_reg_page_headers
  end

end