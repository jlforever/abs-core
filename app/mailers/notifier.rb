class Notifier < ActionMailer::Base

  def test_email
    mail(:to => 'info@alphabetaschool.org', :from => 'ABLS Info <info@alphabetaschool.org>', :subject => 'This is a test email')
  end
  
  def contact_us_email(contact_info)
    to_address = build_to_address(contact_info[:email], contact_info[:first_name], contact_info[:last_name])
    mail(:to => 'info@alphabetaschool.org', 
      :from => to_address, 
      :subject => "#{to_address} is interested in ABLS")
  end
  
  def build_to_address(email, first_name, last_name)
    name = first_name.to_s + " " + last_name.to_s
    name + "<" + email + ">"
  end
  private :build_to_address

end