class Notifier < ActionMailer::Base

  def test_email
    mail(:to => 'admin@alphabetaschool.org', :from => 'ABLS Info <admin@alphabetaschool.org>', :subject => 'This is a test email')
  end
  
  def contact_us_email(contact_info)
    to_address = build_to_address(contact_info['email_address'], contact_info['parent_first_name'], contact_info['parent_last_name'])
    @contact_info = contact_info
    mail(:to => 'info@alphabetaschool.org', 
      :from => to_address, 
      :subject => "#{to_address} is interested in ABLS")
  end
  
  def build_to_address(email, first_name, last_name)
    name = first_name.to_s + " " + last_name.to_s
    name + " <" + email + ">"
  end
  private :build_to_address

  def send_registration_confirmation_email(to_address, parent_first_name, reg_created_date, fee_location)
    @parent_first_name = parent_first_name
    @reg_created_valid_until = (reg_created_date + 2.week).strftime("%m-%d-%Y %H:%M:%S")
    fee_template = Registration.fee.detect { |hash| hash['location'] == fee_location }
    @fee = fee_template ? fee_template['fee'].to_i : 0
    mail(:to => to_address,
      :from => 'info@alphabetaschool.org',
      :subject => 'Thank you for registering with ABLS')
  end
  
  def send_registration_notification_to_abls_admin(registered_data)
    @class_location = registered_data.location
    @child_first_name = registered_data.child_first_name
    @child_last_name = registered_data.child_last_name
    @parent_first_name = registered_data.parent_first_name
    @parent_last_name = registered_data.parent_last_name
    @level_age_group = registered_data.class_level
    @day_phone = registered_data.parent_day_phone
    @cell_phone = registered_data.parent_cell_phone
    @email = registered_data.parent_email
    @registered_on = registered_data.created_at.strftime('%m-%d-%Y %H:%M:%S')
    
    mail(to: 'info@alphabetaschool.org', 
     from: 'info@alphabetaschool.org', 
     subject: "Kid: #{@child_first_name} #{@child_last_name}, Parent: #{@parent_first_name} #{@parent_last_name} just registered!")
  end
  
end