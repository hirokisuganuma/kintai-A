class WorksController < ApplicationController

  def edit
    @user = User.find(params[:id])
    @first_day = Date.parse(params[:date])
    @last_day = @first_day.end_of_month
    @works = @user.works.where('day >= ? and day <= ?', @first_day, @last_day).order('day')
    @worked_sum = @user.works.where.not(attendance_time: nil).count
  end

  def create
    @user = User.find(params[:user_id])
    @work = @user.works.find_by(day: Date.today)
    if @work.attendance_time.nil?
      @work.update_attributes(attendance_time: current_time)
      @work.save(validate: false)
      flash[:info] = 'おはようございます。'
    elsif @work.leaving_time.nil?
      @work.update_attributes(leaving_time: current_time)
      @work.save(validate: false)
      flash[:info] = 'おつかれさまでした。'
    else
      flash[:danger] = 'トラブルがあり、登録出来ませんでした。'
    end
    redirect_to @user
  end

  def update
    @user = User.find(params[:id])
      works_params.each do |id, time|
        work = Work.find(id)
          if work.day > Date.current && !current_user.admin?
          elsif time["attendance_time"].blank? && time["leaving_time"].blank?
          elsif time["attendance_time"].blank? || time["leaving_time"].blank?
            flash[:warning] = '一部編集が無効となった項目があります。'
          elsif time["attendance_time"].to_s > time["leaving_time"].to_s
            flash[:warning] = '出社時間より退社時間が早い項目がありました'
          else
                work.update_attributes(time)
                  flash[:success] = '勤怠時間を更新しました。なお本日以降の更新はできません。'
          end
      end 
    redirect_to edit_works_path(@user, params:{ id: @user.id, first_day: params[:first_day]})
  end

  private
    def works_params
      params.permit(works: [:attendance_time, :leaving_time, :remarks])[:works]
    end

end