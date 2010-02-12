# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  
  before_filter :track_user

private
  
  def track_user        
    # block ownership is tracked using browser cookies
    cookies[:signature] = {:value => ActiveSupport::SecureRandom.base64, :expires => 1.year.from_now} if cookies[:signature].blank?
  end

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
end
