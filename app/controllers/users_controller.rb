class UsersController < ApplicationController

    def show
      @user = User.find(params[:id])
      @articles = @user.articles.paginate(page: params[:page], per_page: 5)
    end

    def new
      @user = User.new
    end   

    def index
      @users = User.paginate(page: params[:page], per_page: 5)
    end

    def edit
      @user = User.find(params[:id])
    end

    def create
    @user = User.new(user_params)
    respond_to do |format|
      if @user.save
        format.html { redirect_to articles_path, notice: "Welcome to the test app #{@user.username}, you have succesfully signed up." } 
        format.json { render :show, status: :created, location: @article_path }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      @user = User.find(params[:id])
      if @user.update(user_params)
        format.html { redirect_to @user, notice: "Your account information was succcesfully updated." }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end




    def user_params
      params.require(:user).permit(:username, :email, :password)
    end

end 
