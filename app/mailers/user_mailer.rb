class UserMailer < ActionMailer::Base

    default from: "registration@bad-apples.com"

 def registration_confirmation(user)
    @user = user
    mail(to: "#{user.full_name} <#{user.email}>", subject: "Registration Confirmation")
 end

end
