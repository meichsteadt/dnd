class ApplicationController < ActionController::Base
  before_action :edit_mode

  def edit_mode
    if params[:edit_mode]
      session[:edit_mode] = params[:edit_mode] == "true"
    end
    @edit_mode = session[:edit_mode] ? session[:edit_mode] : false
  end
end
