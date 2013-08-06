require 'spec_helper'

describe Registration do  
  let!(:reg) { FactoryGirl.create(:registration) }
  
  describe "With an existing registration having unique child first and last name and parent first name" do
    it "blocks creating of another registration with an used combo of child first and last name and parent first name" do
      expect {
        Registration.create!(:child_first_name => reg.child_first_name, 
          :child_last_name => reg.child_last_name,
          :parent_first_name => reg.parent_first_name,
          :parent_last_name => 'Blah',
          :child_dob => Time.now - 6.years,
          :parent_email => reg.parent_email,
          :parent_day_phone => reg.parent_day_phone,
          :parent_cell_phone => reg.parent_cell_phone)
      }.to raise_error
    end
    
    it "proceeds to create the registration with variation of child's first name" do
      Registration.create!(:child_first_name => "SomeFirstName", 
        :child_last_name => reg.child_last_name,
        :parent_first_name => reg.parent_first_name,
        :parent_last_name => 'Blah',
        :child_dob => Time.now - 6.years,
        :parent_email => reg.parent_email,
        :parent_day_phone => reg.parent_day_phone,
        :parent_cell_phone => reg.parent_cell_phone)
      Registration.count.should == 2
    end
    
    it "proceeds to create the registration with variation of child's last name" do
      Registration.create!(:child_first_name => reg.child_first_name, 
        :child_last_name => "SomeLastName",
        :parent_first_name => reg.parent_first_name,
        :parent_last_name => 'Blah',
        :child_dob => Time.now - 6.years,
        :parent_email => reg.parent_email,
        :parent_day_phone => reg.parent_day_phone,
        :parent_cell_phone => reg.parent_cell_phone)
      Registration.count.should == 2
    end
    
    it "proceeds to create the registration with variation of parent's first name" do
      Registration.create!(:child_first_name => reg.child_first_name, 
        :child_last_name => reg.child_last_name,
        :parent_first_name => "SomeParentFirstName",
        :parent_last_name => 'Blah',
        :child_dob => Time.now - 6.years,
        :parent_email => reg.parent_email,
        :parent_day_phone => reg.parent_day_phone,
        :parent_cell_phone => reg.parent_cell_phone)
      Registration.count.should == 2
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
          :parent_cell_phone => reg.parent_cell_phone)
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
          :parent_cell_phone => reg.parent_cell_phone)
      }.to raise_error
    end
  end
end
