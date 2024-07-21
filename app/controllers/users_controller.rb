class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :require_user, only: [:edit, :update]
  before_action :require_same_user, only: [:edit, :update, :destroy]

    def show
      @articles = @user.articles.paginate(page: params[:page], per_page: 5)
    end

    def new
      @user = User.new
    end   

    def index
      @users = User.paginate(page: params[:page], per_page: 5)
    end

    def edit
    end

  
  def create
    @user = User.new(user_params)
    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: "Welcome to the test app #{@user.username}, you have succesfully signed up." }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: "Your account information was succcesfully updated." }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @user.destroy!
    respond_to do |format|
      format.html { redirect_to users_path, notice: "Account and all associated articles are successfully deleted.." }
      format.json { head :no_content }
    end
  end



    private
    def user_params
      params.require(:user).permit(:username, :email, :password)
    end

    def set_user
      @user = User.find(params[:id])
    end

    def require_same_user
      if current_user != @user && !current_user.admin?
        flash[:alert] = "You can only edit or delete your own account.. "
        redirect_to @user
      end
    end

end 
