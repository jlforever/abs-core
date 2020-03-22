require 'prawn'

class Pdfs::EnrollmentConfirmation

  def initialize(confirm_date, group)
    @confirm_date = confirm_date
    @group = group
    @session_stats = YAML.load(File.read(File.join(Rails.root, 'public', 
      'support_files', 'registration', 'session_stats.yml')))
  end
  
  def parse_session_info
    @session_stats.detect do |key, value|
      @confirm_date >= (value['start_date'].to_time - 3.weeks) &&
        @confirm_date <= value['end_date'].to_time
    end
  end
  private :parse_session_info
  
  def call
    session_info = parse_session_info
    @tempfile = Tempfile.new('reciept.pdf')
    s_date = session_info.last['start_date']
    e_date = session_info.last['end_date']
    g = @group
    
    Prawn::Document.generate('hello.pdf') do
      image File.join(Rails.root, 'app', 'assets', 
        'images', 'abs-school-logo.png')
      move_down 20
      text "Dear Alpha Beta Families,"
      move_down 20
      text "I am very excited to have your children join Alpha Beta Language School's Chinese language immersion program. Alpha Beta will make the best effort to provide the most qualified Mandarin classes to your children. this email a confirmation of enrollment."
      move_down 20
      text "<b>Schedule</b>: ", :inline_format => true
      if g.downcase == 'panda'
        text "Beginner Panda Group (3-5 years old) #{s_date} to #{e_date}"
      else
        text "Beginner Star Group (5-10 years old) #{s_date} to #{e_date}" 
      end
      move_down 20
      text "<b>Procedure</b>:", :inline_format => true
      text "Students will be dropped off at Alpha Beta, located at 9 Dobson Road, Braintree, MA. We take attendance for each class. If the weather permits, students may have up to 30 minutes outdoor class to play Chinese games. It is important that students to be picked up on time. If there is a chance that the responsible adult will sometimes be unable to pick up your child in the event of an anticipated delay. We will need written consent for your child to be dismissed to someone other than the individual(s) indicated on your registration form. There is no nurse or other medical staff on duty during the classes. Employees are not permitted to administer medication. Please take this into consideration."
      move_down 20
      text "I strongly believe that parents can contribute greatly to the success of their children in learning a foreign language. When our website is fully constructed, parents can find rich resources you can use to help your children practice Mandarin at home. Young children will enjoy repeatedly watching the videos to learn Mandarin. I hope to make you all partners in my program by actively communicating with you throughout the duration of the program." 
      move_down 20
      text "Through email updates I will share with you the highlights of our curriculum and other information that I feel you should have or watch. I hope that this can aid us in our mutual efforts to make the most of each student's learning experience with Alpha Beta."
      move_down 30
      text "<font size='13'><b><i>Alpha Beta Language School</i></b></font>", :inline_format => true
      move_down 12
      text "Serena <Yan> Li"
      text "www.alphabetaschool.org"
      text "Email: info@alphabetaschool.org"
      text "Phone: 781-519-9319"
    end
    
  end

  def self.call(confirm_date, group)
    new(confirm_date, group).call
  end

end