class ChaptersController < ApplicationController
  before_action :set_chapter, only: %i[ show edit update destroy ]
  before_action :set_book
  # GET /chapters or /chapters.json
  def index
    @chapters = Chapter.all
  end

  # GET /chapters/1 or /chapters/1.json
  def show
    respond_to do |format|
      format.html
      format.json
      format.js
    end
  end

  # GET /chapters/new
  def new
    @chapter = @book.chapters.new
    respond_to do |format|
      format.html
      format.json
      format.js { render 'show.js.erb' }
    end
  end

  # GET /chapters/1/edit
  def edit
    @chapter_edit = true
    respond_to do |format|
      format.html
      format.json
      format.js { render 'show.js.erb'}
    end
  end

  # POST /chapters or /chapters.json
  def create
    @chapter = @book.chapters.new(chapter_params)
    respond_to do |format|
      if @chapter.save
        @chapter.update_orders(new_order)
        @append = true
        format.html { redirect_to @book.campaign, notice: "Chapter was successfully created." }
        format.json { render :show, status: :created, location: @chapter }
        format.js { render 'show.js.erb' }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @chapter.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /chapters/1 or /chapters/1.json
  def update
    respond_to do |format|
      if @chapter.update(chapter_params)
        @chapter.update_orders(new_order)
        format.html { redirect_to @book.campaign, notice: "Chapter was successfully updated." }
        format.json { render :show, status: :ok, location: @chapter }
        format.js { render 'show.js.erb' }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @chapter.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /chapters/1 or /chapters/1.json
  def destroy
    @chapter.destroy
    respond_to do |format|
      format.html { redirect_to @book.campaign, notice: "Chapter was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_chapter
      @chapter = Chapter.find(params[:id])
    end

    def set_book
      @book = Book.find(params[:book_id])
      @campaign = @book.campaign
    end

    # Only allow a list of trusted parameters through.
    def chapter_params
      params.require(:chapter).permit(:name, :desc)
    end

    def new_order
      params.require(:chapter).permit(:order)[:order].to_i
    end
end
