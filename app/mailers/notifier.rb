class Notifier < ActionMailer::Base

  def test_email
    mail(:to => 'info@alphabetaschool.org', :from => 'ABLS Info <info@alphabetaschool.org>', :subject => 'This is a test email')
  end

end