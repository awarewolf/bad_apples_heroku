class UserMailer < ActionMailer::Base
    default :from => "admin@localhost:3000"

 def registration_confirmation(user)
    @user = user
    mail(to: "#{user.full_name} <#{user.email}>", subject: "Registration Confirmation")
 end

end
