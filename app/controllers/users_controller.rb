class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: [:destroy, :edit_basic_info, :update_basic_info]

  require 'csv'

  def index
    @users = User.paginate(page: params[:page]).search(params[:search])
      if current_user.admin?
      else
        redirect_to(root_path) 
        flash[:warning] = "ほかのユーザにはアクセスできません"
      end

      if params[:commit] == "CSVをインポート"
      
        if params[:users_file].content_type == "text/csv"
            registered_count = import_users
            unless @errors.count == 0
              flash[:danger] = "#{@errors.count}件登録に失敗しました"
            end
            unless registered_count == 0
              flash[:success] = "#{registered_count}件登録しました"
            end
            redirect_to users_url(error_users: @errors)
        else
          flash[:danger] = "CSVファイルのみ有効です"
          redirect_to users_url
        end
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

  def update_by_admin
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "ユーザー情報を更新しました。"
      redirect_to users_path
    else
      redirect_to users_path
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
  
  def working_users
    @users = User.get_working_user.paginate(page: params[:page])
  end

  def csv_output
    date=params[:date].to_datetime
    @works = current_user.works.where(day: date.beginning_of_month..date.end_of_month ).order(:day)
    send_data render_to_string, filename: "#{current_user.name}_#{params[:date].to_time.strftime("%Y年 %m月")}.csv", type: :csv
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "アカウントを削除しました。"
    redirect_to users_url
  end
  

  private

  # CSVインポート
  def import_users
    # 登録処理前のレコード数
    current_user_count = ::User.count
    users = []
    @errors = []
    # windowsで作られたファイルに対応するので、encoding: "SJIS"を付けている
    CSV.foreach(params[:users_file].path, headers: true, encoding: "SJIS") do |row|
      user = User.new({ id: row["id"], name: row["name"], email: row["email"], affiliation: row["affiliation"], worker_number: row["worker_number"], card_id: row["card_id"], basic_time: row["basic_time"], 
                        start_time: row["start_time"], end_time: row["end_time"], sv: row["sv"], admin: row["admin"], password: row["password"]})
      if user.valid?
          users << ::User.new({ id: row["id"], name: row["name"], email: row["email"], affiliation: row["affiliation"], worker_number: row["worker_number"], card_id: row["card_id"], basic_time: row["basic_time"], 
          start_time: row["start_time"], end_time: row["end_time"], sv: row["sv"], admin: row["admin"], password: row["password"]})
      else
        @errors << user.errors.inspect
        Rails.logger.warn(user.errors.inspect)
      end
    end
    # importメソッドでバルクインサートできる
    ::User.import(users)
    # 何レコード登録できたかを返す
    ::User.count - current_user_count
  end
  
    def user_params
      params.require(:user).permit(:name, :email, :password, :affiliation, :basic_time,
                                  :worker_number, :card_id, :start_time, :end_time)
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
      redirect_to(users_url) unless current_user?(@user)
    end

    def admin_user
      redirect_to(top_url) unless current_user.admin?
    end
    

  
end
