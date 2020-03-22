require 'prawn'

class Pdfs::FeeReceivedReceipt
  
  S3_CONTENT_TYPE = 'application/pdf'
  S3_BUCKET_NAME = 'abs_receipt'

  def initialize(parent_name, child_name, received_amount, received_date, group)
    @parent_name = parent_name
    @child_name = child_name
    @received_amount = received_amount
    @received_date = received_date.to_time
    @group = group
    @session_stats = YAML.load(File.read(File.join(Rails.root, 'public', 
      'support_files', 'registration', 'session_stats.yml')))
  end
  
  def parse_session_info
    @session_stats.detect do |key, value|
      @received_date >= (value['start_date'].to_time - 3.weeks) &&
        @received_date <= value['end_date'].to_time
    end
  end
  private :parse_session_info
  
  def call
    session_info = parse_session_info
    @tempfile = Tempfile.new('reciept.pdf')
    p_name = @parent_name
    c_name = @child_name
    g = @group
    r_amt = @received_amount
    c_time = Time.now.strftime("%m-%d-%Y")
    
    Prawn::Document.generate('hello.pdf') do
      image File.join(Rails.root, 'app', 'assets', 
        'images', 'abs-school-logo.png')
      move_down 20
      text "Dear #{p_name}, "
      move_down 20
      text "Thank you for paying the tuition for your child #{c_name}. We are pleased to have your child to be a part of Alpha Beta Language School's curriculum. Below is the summary of what we received:"
      move_down 20
      table([["Session:", session_info.first.split("_").map(&:humanize).join(" ")],
        ["Total Fee:", "$" + "%0.2f" % (session_info.last[g].to_f)],
        ["Paid Fee:", "$" + "%0.2f" % (r_amt.to_f)],
        ["Outstanding Balance:", "$" + "%0.2f" % (session_info.last[g].to_f - r_amt.to_f)]
      ])
      move_down 30
      text "<font size='13'><b><i>Alpha Beta Language School</i></b></font>", :inline_format => true
      move_down 12
      text "Receipt Date: #{c_time}"
      text "www.alphabetaschool.org"
      text "Email: info@alphabetaschool.org"
      text "Phone: 781-519-9319"
    end
  end
  
  def self.call(parent_name, child_name, received_amount, received_date, group)
    new(parent_name, child_name, received_amount, received_date, group).call
  end

end