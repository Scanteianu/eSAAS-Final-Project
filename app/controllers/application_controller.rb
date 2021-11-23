class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :is_current_user_verified
  def is_current_user_verified
    @is_current_user_verified = verify_user(session[:username])
  end
  
  def verify_user(user_email)
    #check if it has columbia.edu or barnard.edu
    if user_email.nil?
      return false
    else
      if user_email.include? "columbia.edu" or user_email.include? "barnard.edu"
        return true
      else
        return false
      end
    end
  end
end

