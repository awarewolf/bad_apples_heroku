class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  include SessionsHelper

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  protected

  def restrict_access
    unless current_user
      flash[:alert] = "You must log in."
      redirect_to new_session_path
    end
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def restrict_admin
    unless admin?
      flash[:alert] = "You must be an administrator."
      redirect_to new_session_path
    end
  end

  def admin?
    @current_user.admin if current_user
  end

  helper_method :current_user
  helper_method :restrict_access
  helper_method :restrict_admin
  helper_method :admin?

  private

  def record_not_found
    flash[:alert] = "The record you were looking for was not found."
    redirect_to root_url
  end

end