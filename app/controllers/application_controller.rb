class ApplicationController < ActionController::Base
  before_action :require_login
  before_action :set_action_cable_identifier

  def not_authenticated
    redirect_to new_login_path
  end

  private

  def set_action_cable_identifier
    cookies.encrypted[:session_id] = session.id.to_s
  end
end
