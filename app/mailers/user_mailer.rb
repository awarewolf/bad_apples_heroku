class UserMailer < ActionMailer::Base
    if Rails.env.production?
      @domain == ENV["heroku_domain"]
    else
      @domain == "admin@localhost:3000"
    end

    # default :from => @domain
    default :from => ENV["gmail_username"]

 def registration_confirmation(user)
    @user = user
    mail(to: "#{user.full_name} <#{user.email}>", subject: "Registration Confirmation")
 end

end
