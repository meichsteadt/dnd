class MagicItemsController < ApplicationController
  def show
    @magic_item = MagicItem.find(params[:id])
    @monster = params[:monster] == "true"
    @page = params[:page] == "true"
    respond_to do |format|
      format.js
    end
  end
end
