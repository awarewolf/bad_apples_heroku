class UserMailer < ActionMailer::Base
    if Rails.env.production?
      domain == "registration@bad-apples.herokuapp.com"
    else
      domain == "admin@localhost:3000"
    end

    # default :from => @domain
    default from: domain

 def registration_confirmation(user)
    @user = user
    mail(to: "#{user.full_name} <#{user.email}>", subject: "Registration Confirmation")
 end

end
