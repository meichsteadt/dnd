class InkarnateController < ApplicationController
  before_action :authenticate_inkarnate, only: [:index]

  def index
    @maps = InkarnateApi.get_maps
  end

  def new
  end

  def create
    response = InkarnateApi.login(*login_params.to_h.to_a.map(&:last))
    begin
      auth_token = response["authToken"]
      session[:inkarnate_token] = auth_token
      InkarnateApi.token = auth_token
      redirect_to '/campaigns'
    rescue
      flash[:notice] = "That didn't seem to work :/"
      redirect_to new_inkarnate_path
    end
  end

  private

  def login_params
    params.permit(:email, :password)
  end

  def authenticate_inkarnate
    token = session[:inkarnate_token]
    puts token
    if token
      InkarnateApi.token = token if InkarnateApi.token.nil?
    else
      redirect_to new_inkarnate_path
    end
  end
end
