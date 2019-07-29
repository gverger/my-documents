class ApplicationController < ActionController::Base
  before_action :require_login

  def not_authenticated
    redirect_to new_login_path
  end
end
