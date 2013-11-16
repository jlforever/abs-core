require 'spec_helper'

describe Notifier do
  
  describe "send_registration_confirmation_email" do
    let(:to_address) { 'test@example.com' }
    let(:parent_first_name) { 'some_person' }
    
    before(:each) do
      @email = Notifier.send_registration_confirmation_email(to_address, parent_first_name, Time.zone.now)
    end
    
    it "sets the proper from address of the email" do
      @email.from.should == ['info@alphabetaschool.org']
    end
    
    it "sets the proper subject of the email" do
      @email.subject.should == 'Thank you for registering with ABLS'
    end
    
    it "sets the proper to address" do
      @email.to.should == [to_address]
    end
    
    it "contains the proper fee amount in email body" do
      @email.body.encoded.should match(Registration.fee)
    end
    
    it "contains the parent's first name in email body" do
      @email.body.encoded.should match(parent_first_name)
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
      @email.to.should == ['info@alphabetaschool.org']
    end
    
    it "contains the appropriate body info" do
      @email.body.encoded.should match("Others")
      @email.body.encoded.should match("Something")
      @email.body.encoded.should match("Enrollment")
      @email.body.encoded.should match("Boston/Cambridge")
    end
    
  end

end