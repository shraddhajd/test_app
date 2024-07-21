class CategoriesController < ApplicationController
  before_action :set_category, only: %i[ show edit update destroy ]
  before_action :require_admin, except: %i[index show]  

  # GET /categories or /categories.json
  def index
    @categories = Category.paginate(page: params[:page], per_page: 4)
  end

  # GET /categories/1 or /categories/1.json
  def show
    # @category = Category.find(params[:id])
    @articles = @category.articles.paginate(page: params[:page], per_page: 3)
  end

  # GET /categories/new
  def new
    @category = Category.new
  end

  # GET /categories/1/edit
  def edit
    @category = Category.find(params[:id])
  end

  # POST /categories or /categories.json
  def create
    respond_to do |format|
    @category = Category.new(category_params)
      if @category.save
        format.html { redirect_to @category, notice: "Category name successfully created." }
        format.json { render :show, status: :ok, location: @category }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /categories/1 or /categories/1.json
  def update
    respond_to do |format|
      if @category.update(category_params)
        format.html { redirect_to category_url(@category), notice: "Category name successfully updated." }
        format.json { render :show, status: :ok, location: @category }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /categories/1 or /categories/1.json
  def destroy
    @category.destroy!
    respond_to do |format|
      format.html { redirect_to categories_url, notice: "Category was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    def set_category
      @category = Category.find(params[:id])
    end

    def category_params
      params.require(:category).permit(:name)
    end

    def require_admin
      if !(logged_in? && current_user.admin?)
        flash[:alert] = "Only admins can perform that action"
        redirect_to categories_url
    end
  end
end
