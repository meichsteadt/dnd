class PagesController < ApplicationController
  before_action :set_page, only: %i[ show edit update destroy ]
  before_action :set_chapter

  # GET /pages or /pages.json
  def index
    @pages = Page.all
  end

  # GET /pages/1 or /pages/1.json
  def show
    respond_to do |format|
      format.html
      format.json
      format.js
    end
  end

  # GET /pages/new
  def new
    @page = @chapter.pages.new
    @append = true
    respond_to do |format|
      format.html
      format.json
      format.js { render 'show.js.erb'}
    end
  end

  # GET /pages/1/edit
  def edit
    @page_edit = true
    respond_to do |format|
      format.html
      format.json
      format.js { render 'show.js.erb'}
    end
  end

  # POST /pages or /pages.json
  def create
    @page = @chapter.pages.new(page_params)

    respond_to do |format|
      if @page.save
        @page.update_orders(new_order)
        format.html { redirect_to @page, notice: "Page was successfully created." }
        format.json { render :show, status: :created, location: @page }
        format.js { render 'show.js.erb' }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @page.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /pages/1 or /pages/1.json
  def update
    respond_to do |format|
      if @page.update(page_params)
        @page.update_orders(new_order)
        format.html { redirect_to @page, notice: "Page was successfully updated." }
        format.json { render :show, status: :ok, location: @page }
        format.js { render 'show.js.erb' }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @page.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pages/1 or /pages/1.json
  def destroy
    @page.destroy
    respond_to do |format|
      format.html { redirect_to pages_url, notice: "Page was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_page
      @page = Page.find(params[:id])
    end

    def set_chapter
      @chapter = Chapter.find(params[:chapter_id])
      @book = @chapter.book
      @campaign = @book.campaign
    end

    # Only allow a list of trusted parameters through.
    def page_params
      params.require(:page).permit(:html, :name)
    end

    def new_order
      params.require(:page).permit(:order)[:order].to_i
    end
end
