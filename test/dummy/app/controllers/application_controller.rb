class ApplicationController < ActionController::Base
  include PunditCan::LoadAndAuthorize

  def pundit_user
    User.first
  end
end
