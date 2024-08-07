class ArticlesController < ApplicationController
  before_action :set_article, only: %i[ show edit update destroy ]
  before_action :require_user, expect: [:show, :index]
  before_action :require_same_user, only: [:edit, :update, :destroy]

  def index
    @articles = Article.paginate(page: params[:page], per_page: 5)
  end

  def show
      @article = Article.find(params[:id])
  end

  def new

    @article = Article.new
  end

  def edit
    
  end


  def create
    @article = Article.new(article_params)
    @article.user = current_user
    respond_to do |format|
      if @article.save
        format.html { redirect_to article_url(@article), notice: "Article was successfully created." }
        format.json { render :show, status: :created, location: @article }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /articles/1 or /articles/1.json
  def update
    respond_to do |format|
      if @article.update(article_params)
        format.html { redirect_to article_url(@article), notice: "Article was successfully updated." }
        format.json { render :show, status: :ok, location: @article }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end


  # DELETE /articles/1 or /articles/1.json

  def destroy
    @article.destroy!
    respond_to do |format|
      format.html { redirect_to articles_url, notice: "Articles was successfully destroyed." }
      format.json { head :no_content }
    end
  end



  private
    # Use callbacks to share common setup or constraints between actions.
    def set_article
      @article = Article.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def article_params
      params.require(:article).permit(:title, :description, category_ids: [])
    end

  def require_same_user
    if current_user !=@article.user && !current_user.admin?
      flash[:alert] = "You can only edit or delete your own article.. "
      redirect_to @article
    end
  end

end
