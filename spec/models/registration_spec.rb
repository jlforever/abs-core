require 'spec_helper'

describe Registration do  
  let!(:reg) { FactoryGirl.create(:registration) }
  
  describe "With an existing registration having unique child first and last name and parent first name" do
    it "blocks creating of another registration with an used combo of child first and last name and parent first name" do
      expect {
        Registration.create!(:child_first_name => reg.child_first_name, 
          :child_last_name => reg.child_last_name,
          :class_level => reg.class_level,
          :location => reg.location,
          :parent_first_name => reg.parent_first_name,
          :parent_last_name => 'Blah',
          :address1 => reg.address1,
          :address2 => reg.address2,
          :city => reg.city,
          :state => reg.state,
          :zip => reg.zip,
          :child_dob => Time.now - 6.years,
          :parent_email => reg.parent_email,
          :emergency_contact_name => reg.emergency_contact_name,
          :emergency_contact_phone => reg.emergency_contact_phone,
          :parent_day_phone => reg.parent_day_phone,
          :parent_cell_phone => reg.parent_cell_phone)
      }.to raise_error
    end
    
    it 'proceeds to create the registration with the variation of class location' do
      Registration.create!(:child_first_name => "SomeFirstName", 
        child_last_name: reg.child_last_name,
        :class_level => reg.class_level,
        :location => 'Braintree - location',
        :parent_first_name => reg.parent_first_name,
        :parent_last_name => 'Blah',
        :address1 => reg.address1,
        :address2 => reg.address2,
        :city => reg.city,
        :state => reg.state,
        :zip => reg.zip,
        :child_dob => Time.now - 6.years,
        :parent_email => reg.parent_email,
        :emergency_contact_name => reg.emergency_contact_name,
        :emergency_contact_phone => reg.emergency_contact_phone,
        :parent_day_phone => reg.parent_day_phone,
        :parent_cell_phone => reg.parent_cell_phone)
      Registration.count.should == 2
    end
    
    it 'proceeds to create the registration with variation of class level (child age group)' do
      Registration.create!(:child_first_name => "SomeFirstName", 
        child_last_name: reg.child_last_name,
        :class_level => 'Blah class level',
        :location => reg.location,
        :parent_first_name => reg.parent_first_name,
        :parent_last_name => 'Blah',
        :address1 => reg.address1,
        :address2 => reg.address2,
        :city => reg.city,
        :state => reg.state,
        :zip => reg.zip,
        :child_dob => Time.now - 6.years,
        :parent_email => reg.parent_email,
        :emergency_contact_name => reg.emergency_contact_name,
        :emergency_contact_phone => reg.emergency_contact_phone,
        :parent_day_phone => reg.parent_day_phone,
        :parent_cell_phone => reg.parent_cell_phone)
      Registration.count.should == 2
    end
    
    it "proceeds to create the registration with variation of child's first name" do
      Registration.create!(:child_first_name => "SomeFirstName", 
        :child_last_name => reg.child_last_name,
        :class_level => reg.class_level,
        :location => reg.location,
        :parent_first_name => reg.parent_first_name,
        :parent_last_name => 'Blah',
        :address1 => reg.address1,
        :address2 => reg.address2,
        :city => reg.city,
        :state => reg.state,
        :zip => reg.zip,
        :child_dob => Time.now - 6.years,
        :parent_email => reg.parent_email,
        :emergency_contact_name => reg.emergency_contact_name,
        :emergency_contact_phone => reg.emergency_contact_phone,
        :parent_day_phone => reg.parent_day_phone,
        :parent_cell_phone => reg.parent_cell_phone)
      Registration.count.should == 2
    end
    
    it "proceeds to create the registration with variation of child's last name" do
      Registration.create!(:child_first_name => reg.child_first_name, 
        :child_last_name => "SomeLastName",
        :class_level => reg.class_level,
        :location => reg.location,
        :parent_first_name => reg.parent_first_name,
        :parent_last_name => 'Blah',
        :address1 => reg.address1,
        :address2 => reg.address2,
        :city => reg.city,
        :state => reg.state,
        :zip => reg.zip,
        :child_dob => Time.now - 6.years,
        :parent_email => reg.parent_email,
        :emergency_contact_name => reg.emergency_contact_name,
        :emergency_contact_phone => reg.emergency_contact_phone,
        :parent_day_phone => reg.parent_day_phone,
        :parent_cell_phone => reg.parent_cell_phone)
      Registration.count.should == 2
    end
    
    it "proceeds to create the registration with variation of parent's first name" do
      Registration.create!(:child_first_name => reg.child_first_name, 
        :child_last_name => reg.child_last_name,
        :class_level => reg.class_level,
        :location => reg.location,
        :parent_first_name => "SomeParentFirstName",
        :parent_last_name => 'Blah',
        :address1 => reg.address1,
        :address2 => reg.address2,
        :city => reg.city,
        :state => reg.state,
        :zip => reg.zip,
        :child_dob => Time.now - 6.years,
        :parent_email => reg.parent_email,
        :emergency_contact_name => reg.emergency_contact_name,
        :emergency_contact_phone => reg.emergency_contact_phone,
        :parent_day_phone => reg.parent_day_phone,
        :parent_cell_phone => reg.parent_cell_phone)
      Registration.count.should == 2
    end
  end
  
  describe 'raises child age error' do
    it 'invalidates and not create the new record' do
      expect {
        Registration.create!( :child_last_name => reg.child_last_name,
          :parent_first_name => "SomeParentFirstName",
          :parent_last_name => 'Blah',
          :child_dob => Time.now - 1.years,
          :parent_email => reg.parent_email,
          :parent_day_phone => reg.parent_day_phone,
          :parent_cell_phone => reg.parent_cell_phone,
          :emergency_contact_name => reg.emergency_contact_name,
          :emergency_contact_phone => reg.emergency_contact_phone)
      }.to raise_error
    end
  end
  
  describe "Missing required fields" do
    it "prevents the creation of a registration without child first name" do
      expect {
        Registration.create!( :child_last_name => reg.child_last_name,
          :parent_first_name => "SomeParentFirstName",
          :parent_last_name => 'Blah',
          :child_dob => Time.now - 6.years,
          :parent_email => reg.parent_email,
          :parent_day_phone => reg.parent_day_phone,
          :parent_cell_phone => reg.parent_cell_phone,
          :emergency_contact_name => reg.emergency_contact_name,
          :emergency_contact_phone => reg.emergency_contact_phone)
      }.to raise_error
    end
    
    it "prevents the creation of a registration without child last name" do
      expect {
        Registration.create!(:child_first_name => reg.child_first_name, 
          :parent_first_name => "SomeParentFirstName",
          :parent_last_name => 'Blah',
          :child_dob => Time.now - 6.years,
          :parent_email => reg.parent_email,
          :parent_day_phone => reg.parent_day_phone,
          :emergency_contact_name => reg.emergency_contact_name,
          :emergency_contact_phone => reg.emergency_contact_phone,
          :parent_cell_phone => reg.parent_cell_phone)
      }.to raise_error
    end
    
    it "prevents the creation of a registration without parent email" do
      expect {
        Registration.create!(:child_first_name => reg.child_first_name, 
          :child_last_name => reg.child_last_name,
          :parent_first_name => "SomeParentFirstName",
          :parent_last_name => 'Blah',
          :child_dob => Time.now - 6.years,
          :parent_day_phone => reg.parent_day_phone,
          :emergency_contact_name => reg.emergency_contact_name,
          :emergency_contact_phone => reg.emergency_contact_phone,
          :parent_cell_phone => reg.parent_cell_phone)
      }.to raise_error
    end
  end
  
  describe "wrong phone format" do
    it "throws validation error when day phone number format is invalid" do
      expect {
        Registration.create!(:child_first_name => reg.child_first_name, 
          :child_last_name => reg.child_last_name,
          :parent_first_name => "SomeParentFirstName",
          :parent_last_name => 'Blah',
          :child_dob => Time.now - 6.years,
          :parent_email => reg.parent_email,
          :parent_day_phone => "123.4563-6896",
          :emergency_contact_name => reg.emergency_contact_name,
          :emergency_contact_phone => reg.emergency_contact_phone,
          :parent_cell_phone => reg.parent_cell_phone)
      }.to raise_error
    end
  end
  
  describe ".fee" do
    it "specifies the session fee" do
      Registration.fee.should == [
        { 'location' => 'boston', 'fee' => '300' },
        { 'location' => 'braintree', 'fee' => '190' },
      ]
    end
  end
  
  describe '#notify_abls_admin_via_email' do
    let(:mail1) { mock(Mail::Message) }
    
    before(:each) do
      mail1.stub(:deliver)
    end
    
    it "calls notifier to mail out abls registration notification email" do
      Notifier.should_receive(:send_registration_notification_to_abls_admin).
        and_return(mail1)
      Registration.create!(:child_first_name => reg.child_first_name, 
        :child_last_name => reg.child_last_name,
        :class_level => reg.class_level,
        :location => reg.location,
        :parent_first_name => "SomeParentFirstName",
        :parent_last_name => 'Blah',
        :address1 => reg.address1,
        :address2 => reg.address2,
        :city => reg.city,
        :state => reg.state,
        :zip => reg.zip,
        :child_dob => Time.now - 6.years,
        :parent_email => reg.parent_email,
        :emergency_contact_name => reg.emergency_contact_name,
        :emergency_contact_phone => reg.emergency_contact_phone,
        :parent_day_phone => reg.parent_day_phone,
        :parent_cell_phone => reg.parent_cell_phone)
    end
  end
  
  describe "#created_registration_email" do
    
    let(:mail1) { mock(Mail::Message) }
    
    before(:each) do
      mail1.stub(:deliver)
    end
    
    it "calls notifier to mail out registration confirmation email" do
      Notifier.should_receive(:send_registration_confirmation_email).
        and_return(mail1)
      Registration.create!(:child_first_name => reg.child_first_name, 
        :child_last_name => reg.child_last_name,
        :class_level => reg.class_level,
        :location => reg.location,
        :parent_first_name => "SomeParentFirstName",
        :parent_last_name => 'Blah',
        :address1 => reg.address1,
        :address2 => reg.address2,
        :city => reg.city,
        :state => reg.state,
        :zip => reg.zip,
        :child_dob => Time.now - 6.years,
        :parent_email => reg.parent_email,
        :emergency_contact_name => reg.emergency_contact_name,
        :emergency_contact_phone => reg.emergency_contact_phone,
        :parent_day_phone => reg.parent_day_phone,
        :parent_cell_phone => reg.parent_cell_phone)
    end
  end
end
