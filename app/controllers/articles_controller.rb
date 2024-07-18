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
      if @article.save
        flash[:notice] = "Article was successfully created."
        redirect_to @article
      else
        render new
      end
  end

  # PATCH/PUT /articles/1 or /articles/1.json
  def update
      if @article.update(article_params)
        flash[:notice] = "Article was successfully updated."
        redirect_to @article
      else
        render edit
      end
  end

  # DELETE /articles/1 or /articles/1.json
  def destroy
    @article.destroy!
      flash[:notice] = "Article was successfully destroyed."
      redirect_to articles_url
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_article
      @article = Article.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def article_params
      params.require(:article).permit(:title, :description)
    end

  def require_same_user
    if current_user !=@article.user && !current_user.admin?
      flash[:alert] = "You can only edit or delete your own article.. "
      redirect_to @article
    end
  end

end
