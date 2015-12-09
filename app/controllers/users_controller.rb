class UsersController < ApplicationController

  def new
    @user = User.new
  end

  def create
    # binding.pry
    @user = User.new(user_params)

    if @user.save
      UserMailer.registration_confirmation(@user).deliver
      flash[:success] = "Please confirm your email address to continue"
      redirect_to root_url
    else
      flash[:error] = "Ooooppss, something went wrong!"
      render 'new'
    end
  end

  def confirm_email
    # binding.pry
    user = User.find_by_confirm_token(params[:id])
    if user
      user.email_activate
      flash[:success] = "Welcome to the Bad Apples! Your email has been confirmed. Please sign in to continue."
      redirect_to new_session_url
    else
      flash[:error] = "Sorry. User does not exist"
      redirect_to root_url
    end
  end

  protected

  def user_params
    params.require(:user).permit(:email, :firstname, :lastname, :password, :password_confirmation)
  end

end