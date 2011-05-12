class NotificationMailer < ActionMailer::Base
  default :from => "from@example.com"
  
  def notification_email(message,user,group)
    mail(:to=>user.email, :subject=>"Update from #{group.title}") do |format|
      format.text {render :text=>message}
    end
  end
end
