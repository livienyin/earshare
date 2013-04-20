class EarshareMailer < ActionMailer::Base
  default :to => "livienyin@gmail.com"

  def form_email(from, subject, body)
  	@body = body
  	@from = from
  	mail(:from => from, :subject => subject)
  end

end
