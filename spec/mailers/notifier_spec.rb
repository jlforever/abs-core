require 'spec_helper'

describe Notifier do
  
  describe "send_registration_confirmation_email" do
    let(:to_address) { 'test@example.com' }
    let(:parent_first_name) { 'some_person' }
    let(:fee_location) { 'boston' }
    
    before(:each) do
      @email = Notifier.send_registration_confirmation_email(to_address, parent_first_name, Time.zone.now, fee_location)
    end
    
    it "sets the proper from address of the email" do
      @email.from.should == ['admin@alphabetaschool.org']
    end
    
    it "sets the proper subject of the email" do
      @email.subject.should == 'Thank you for registering with ABLS'
    end
    
    it "sets the proper to address" do
      @email.to.should == [to_address]
    end
    
    it "contains the proper fee amount in email body" do
      @email.body.encoded.should match(Registration.fee.detect { |hash| hash['location'] == fee_location }['fee'].to_i.to_s )
    end
    
    it "contains the parent's first name in email body" do
      @email.body.encoded.should match(parent_first_name)
    end
  end
  
  describe 'send_registration_notification_to_abls_admin' do
    let(:registered_data) do
      OpenStruct.new(
        child_first_name: 'Someone',
        child_last_name: 'Anyone',
        parent_first_name: 'Time',
        parent_last_name: 'CanTell',
        location: 'Blah blah blah',
        parent_day_phone: '222-333-4444',
        parent_cell_phone: '333-444-5555',
        parent_email: 'aeiou@aeiou.com',
        class_level: 'small, very small',
        created_at: Time.local(2014, 2, 8, 10, 0, 0)
      )
    end
    
    before(:each) do
      @email = Notifier.send_registration_notification_to_abls_admin(registered_data)
    end
    
    it 'sets the proper email subject' do
      child_first_name = registered_data.child_first_name
      child_last_name = registered_data.child_last_name
      parent_first_name = registered_data.parent_first_name
      parent_last_name = registered_data.parent_last_name
      
      @email.subject.should == "Kid: #{child_first_name} #{child_last_name}, Parent: #{parent_first_name} #{parent_last_name} just registered!"
    end
    
    it 'details the kids full name' do
      @email.body.encoded.should match(registered_data.child_first_name + ' ' + registered_data.child_last_name)
    end
    
    it 'details parents full name' do
      @email.body.encoded.should match(registered_data.parent_first_name + ' ' + registered_data.parent_last_name)
    end
    
    it 'details the class location of the registerer' do
      @email.body.encoded.should match(registered_data.location)
    end
    
    it 'details the class level age group of the kid' do
      @email.body.encoded.should match(registered_data.class_level)
    end
    
    it 'details the parent email' do
      @email.body.encoded.should match(registered_data.parent_email)
    end
    
    it 'details the registered date time' do
      @email.body.encoded.should match(registered_data.created_at.strftime('%m-%d-%Y %H:%M:%S'))
    end
    
    it 'details the contactable day phone number' do
      @email.body.encoded.should match(registered_data.parent_day_phone)
    end
    
    it 'details the contactable cell phone number' do
      @email.body.encoded.should match(registered_data.parent_cell_phone)
    end
  end

  describe "contact_us_email" do
    
    before(:each) do
      @contact_info = {
        "picked_interest"=>"Enrollment", 
        "picked_loi"=>["Others"], 
        "parent_first_name"=>"Jiapneg", 
        "parent_last_name"=>"Ji", 
        "phone_number"=>"6262286946", 
        "email_address"=>"aeio@gmail.com", 
        "metro_area" => "Boston/Cambridge",
        "notes"=>{"text"=>"Something"}, 
        "commit"=>"Submit"
      }
      @email = Notifier.contact_us_email(@contact_info)
    end
    
    it "sets the proper from address of the email" do
      @email.from.should == [@contact_info['email_address']]
    end
    
    it "sets the proper subject of the email" do
      @email.subject.should == "#{@contact_info['parent_first_name']} #{@contact_info['parent_last_name']} <#{@contact_info['email_address']}> is interested in ABLS"
    end
    
    it "sets the proper to address of the email" do
      @email.to.should == ['admin@alphabetaschool.org']
    end
    
    it "contains the appropriate body info" do
      @email.body.encoded.should match("Others")
      @email.body.encoded.should match("Something")
      @email.body.encoded.should match("Enrollment")
      @email.body.encoded.should match("Boston/Cambridge")
    end
    
  end

end