FactoryGirl.define do
  
  factory :registration, :class => Registration do
    class_level 'Beginner Panda Group'
    location 'Boston - Brimmer St'
    child_first_name 'John'
    child_last_name 'Greene'
    parent_first_name 'Mary'
    parent_last_name 'Greene'
    child_dob Time.local(2009, 10, 15, 12, 0, 0)
    parent_email 'mary.greene@example.com'
    parent_day_phone '123-456-7890'
    parent_cell_phone '456-789-0000'
    address1 "1 Main Street"
    city "SomeCity"
    state "SomeState"
    zip "12345"
    emergency_contact_name "parent name"
    emergency_contact_phone "1235468790"
  end
  
end