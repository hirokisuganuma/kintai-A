class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: [:destroy, :edit_basic_info, :update_basic_info]

  def index
    @users = User.paginate(page: params[:page]).search(params[:search])
      if current_user.admin?
      else
        redirect_to(root_path) 
        flash[:warning] = "ほかのユーザにはアクセスできません"
      end
  end

  def show
    @user = User.find(params[:id])
    if    current_user.admin? 
    elsif current_user != User.find(params[:id]) 
        redirect_to(root_url) 
        flash[:warning] = "ほかのユーザにはアクセスできません"
    end
    if params[:first_day].nil?
      @first_day = Date.today.beginning_of_month
    else
      @first_day = Date.parse(params[:first_day])
    end
      @last_day = @first_day.end_of_month
      @works = @user.works.where('day >= ? and day <= ?', @first_day, @last_day).order('day')
        unless  @user.works.find_by(day: @first_day)
                @first_day.all_month.each do |day|
                work = Work.new(day: day,user_id: @user.id)
                work.save(validate: false)
                end
        end
    @worked_sum = @user.works.where.not(attendance_time: nil).count
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
      if @user.save
        log_in @user
        flash[:success] = "新規登録が完了しました"
        redirect_to user_url(@user)
      else
        render 'new'      
      end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "ユーザー情報を更新しました。"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def edit_basic_info
    @user = User.find(params[:id])
  end

  def update_basic_info
    @user = User.find(params[:id])
      if @user.update_attributes(user_basic_params)
        flash[:success] = "ユーザーの基本情報を更新しました。"
        redirect_to user_path
      else
        render 'edit'
      end
  end
  
  private

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation, :affiliation, :basic_time, :specified_time)
    end

    def user_basic_params
      params.require(:user).permit(:basic_time, :specified_time)
    end

    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "ログインしてください。"
        redirect_to login_url
      end
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(top_url) unless current_user?(@user)
    end

    def admin_user
      redirect_to(top_url) unless current_user.admin?
    end
    
end
