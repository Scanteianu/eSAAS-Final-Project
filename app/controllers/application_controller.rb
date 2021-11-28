class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  def getFromSessionObject(param)
    if $injectedSession
      return $injectedSession[param]
    end
    return session[param]
  end
end
