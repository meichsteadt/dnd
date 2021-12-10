class BooksController < ApplicationController
  before_action :set_book, only: %i[ show edit update destroy ]
  before_action :set_campaign

  # GET /books or /books.json
  def index
    @books = Book.all
  end

  # GET /books/1 or /books/1.json
  def show
    respond_to do |format|
      format.html
      format.json
      format.js
    end
  end

  # GET /books/new
  def new
    @book = @campaign.books.new
    respond_to do |format|
      format.html
      format.json
      format.js {render 'show.js.erb'}
    end
  end

  # GET /books/1/edit
  def edit
    @book_edit = true
    respond_to do |format|
      format.html
      format.json
      format.js { render 'show.js.erb'}
    end
  end

  # POST /books or /books.json
  def create
    @book = @campaign.books.new(book_params)
    respond_to do |format|
      if @book.save
        @book.update_orders(new_order)
        @append = true
        format.html { redirect_to @book.campaign, notice: "Book was successfully created." }
        format.json { render :show, status: :created, location: @book }
        format.js { render 'show.js.erb' }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /books/1 or /books/1.json
  def update
    respond_to do |format|
      if @book.update(book_params)
        @book.update_orders(new_order)
        format.html { redirect_to @book.campaign, notice: "Book was successfully updated." }
        format.json { render :show, status: :ok, location: @book }
        format.js { render 'show.js.erb' }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /books/1 or /books/1.json
  def destroy
    @book.destroy
    respond_to do |format|
      format.html { redirect_to @campaign, notice: "Book was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_book
      @book = Book.find(params[:id])
    end

    def set_campaign
      @campaign = Campaign.find(params[:campaign_id]) if params[:campaign_id]
    end

    # Only allow a list of trusted parameters through.
    def book_params
      params.require(:book).permit(:name, :desc)
    end

    def new_order
      params.require(:book).permit(:order)[:order].to_i
    end
end
