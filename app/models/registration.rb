class Registration < ActiveRecord::Base
  VALID_STATUSES = ['registered', 'paid', 'finished']

  # Registration are considered unique when child's
  # first and last name plus child's parent first name
  # plus the class level and the study location are unique
  #
  # This is a per registration session constraint.
  # A new registration will lift this constraint and allow
  # the registration to be created.
  #
  # Registrations are cleared off once payment is received
  # the clearing will enable new registrations for a new
  # session to be able to create
  #
  #validates :child_first_name, :uniqueness => {
  #  :scope => [:child_last_name, :parent_first_name, :class_level, :location],
  #  :case_sensitive => false
  #}

  # These fields are required to be available when intending to be
  # creating a registration object
  #
  validates_presence_of :class_level
  validates_presence_of :location
  validates_presence_of :child_first_name, :child_last_name, :child_dob
  validates_presence_of :parent_first_name, :parent_last_name, :parent_email
  validates_presence_of :address1, :city, :state, :zip
  validates_presence_of :emergency_contact_name
  validates_presence_of :emergency_contact_phone

  validates :status, inclusion: { in: VALID_STATUSES }

  # Make sure contact phone number entered is present and is in
  # the proper format 
  #
  validates :parent_day_phone, :format => {
    :with => /^\(?([0-9]{3})\)?[-. ]?([0-9]{3})[-. ]?([0-9]{4})$/,
    :message => "can't be blank, check format"
  }

  validates :parent_cell_phone, :format => {
    :with => /^\(?([0-9]{3})\)?[-. ]?([0-9]{3})[-. ]?([0-9]{4})$/,
    :message => "can't be blank, check format"
  }

  validates :parent_email, :format => {
    :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/,
    :message => "check format"
  }

  validate :verify_registration_eligible
  validate :child_must_be_at_least_three_years_old
  validate :second_child_details_must_be_complete

  after_save :created_registration_email
  after_save :notify_abls_admin_via_email

  private

  def verify_registration_eligible
    [:child_last_name, :parent_first_name, :class_level, :location]

    on_going_class = Registration.where(
      child_last_name: self.child_last_name,
      parent_first_name: self.parent_first_name,
      class_level: self.class_level,
      location: self.location).
    where('registrations.status in (?)', ['registered', 'fees_paid']).present?

    if on_going_class
      errors.add(:base, "Your child is currently having a session. Please wait until this session finishes prior to registering again. Thanks")
    end
  end

  def child_must_be_at_least_three_years_old
    three_years_ago = Time.zone.now - 3.years

    if (first_child_invalid = self.child_dob > three_years_ago) ||
         (second_child_invalid = (self.second_child_dob.present? && self.second_child_dob > three_years_ago))
      errors.add(:base, "Your #{first_child_invalid.present? ? 'first' : 'second'} child needs to be at least 3 years old or older in order to register")
    end
  end

  def second_child_details_must_be_complete
    second_child_info = [second_child_first_name, second_child_last_name, second_child_dob, second_child_nickname].reject { |v| v.blank? }.compact

    if second_child_info.size > 0 && second_child_info.size < 4
      errors.add(:base, "You can either skip the second child info or complete all of the second child info")
    end
  end

  def created_registration_email
    teacher = self.class_level.match(/Serena|Amaia|BaoBao/).to_s
    fee_location = self.location.split('-').first.strip.downcase + " #{teacher}"
    Notifier.send_registration_confirmation_email(self.parent_email, 
      self.parent_first_name, self.created_at, fee_location).deliver
  end

  def notify_abls_admin_via_email
    Notifier.send_registration_notification_to_abls_admin(self).deliver
  end

  def self.fee
    ::Registration::FileHelpers.parse_reg_fee
  end

end
