class Registration < ActiveRecord::Base
  
  # Registration are considered unique when child's
  # first and last name plus child's parent first name
  # are unique
  #
  # This is a per registration session constraint.
  # A new registration will lift this constraint and allow
  # the registration to be created.
  #
  validates :child_first_name, :uniqueness => {
    :scope => [:child_last_name, :parent_first_name, :class_level],
    :case_sensitive => false
  }
  
  # These fields are required to be available when intending to be
  # creating a registration object
  #
  validates_presence_of :class_level
  validates_presence_of :child_first_name, :child_last_name, :child_dob
  validates_presence_of :parent_first_name, :parent_last_name, :parent_email
  validates_presence_of :address1, :city, :state, :zip
  validates_presence_of :emergency_contact_phone
  
  # Make sure contact phone number entered is present and is in
  # the proper format 
  #
  validates :parent_day_phone, :format => {
    :with => /^\(?([0-9]{3})\)?[-. ]?([0-9]{3})[-. ]?([0-9]{4})$/,
    :message => "can't be blank, check format!"
  }

  validates :parent_cell_phone, :format => {
    :with => /^\(?([0-9]{3})\)?[-. ]?([0-9]{3})[-. ]?([0-9]{4})$/,
    :message => "can't be blank, check format!"
  }
  
  validates :parent_email, :format => {
    :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/,
    :message => "check format!"
  }
  
  after_save :created_registration_email
  
  def created_registration_email
    Notifier.send_registration_confirmation_email(self.parent_email, 
      self.parent_first_name, self.created_at).deliver
  end
  
  def self.fee
    ::Registration::FileHelpers.parse_reg_fee
  end
  
end
