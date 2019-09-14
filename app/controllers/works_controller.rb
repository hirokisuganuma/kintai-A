class WorksController < ApplicationController

  def edit
    @user = User.find(params[:id])
    if    current_user.admin? 
    elsif current_user != User.find(params[:id]) 
        redirect_to(root_url) 
        flash[:warning] = "ほかのユーザにはアクセスできません"
    end
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
      works_params.each do |id, item|
        work = Work.find(id)
          if work.day > Date.current && !current_user.admin?
            break
            flash[:warning] = '一部編集が無効となった項目があります。'
            redirect_to edit_works_path(@user, params:{ id: @user.id, first_day: params[:first_day]})and return
          if item[:check_tomorrow] == "true"
            if item.fetch("attendance_time").present?
              item["attendance_time"] = Time.parse("#{work.day} #{item.fetch("attendance_time")}") - 9.hour
            else
              item["attendance_time"] = nil
            end
            if item.fetch("leaving_time").present?
              item["leaving_time"]= Time.parse("#{work.day} #{item.fetch("leaving_time")}").tomorrow - 9.hour
            else
              item["leaving_time"]= nil
            end
          else
            if item.fetch("attendance_time").present?
              item["attendance_time"] = Time.parse("#{work.day} #{item.fetch("attendance_time")}") - 9.hour
            else
              item["attendance_time"] = nil
            end
            if item.fetch("leaving_time").present?
              item["leaving_time"]= Time.parse("#{work.day} #{item.fetch("leaving_time")}") - 9.hour
            else
              item["leaving_time"]= nil
            end
          end
          elsif item["attendance_time"].blank? && item["leaving_time"].blank?
          elsif item["attendance_time"].blank? || item["leaving_time"].blank?
            flash[:warning] = '一部編集が無効となった項目があります。'
            redirect_to edit_works_path(@user, params:{ id: @user.id, first_day: params[:first_day]})and return
          elsif item["attendance_time"].to_s > item["leaving_time"].to_s
            flash[:warning] = '出社時間より退社時間が早い項目がありました'
            redirect_to edit_works_path(@user, params:{ id: @user.id, first_day: params[:first_day]})and return
          elsif item["attendance_time"] !~ /\d{2}:00|15|30|45/ then flash[:warning] = '入力は１５分間隔でお願いします。'
            redirect_to edit_works_path(@user, params:{ id: @user.id, first_day: params[:first_day]})and return
          elsif item["leaving_time"] !~ /\d{2}:00|15|30|45/ then flash[:warning] = '入力は１５分間隔でお願いします。'
            redirect_to edit_works_path(@user, params:{ id: @user.id, first_day: params[:first_day]})and return
          else
            item["attendance_after_chenge"] = item["attendance_time"]
            item["liaving_after_chenge"] = item["leaving_time"]
            item.delete("attendance_time")
            item.delete("leaving_time")
            work.update_attributes(item)
              work.save(validate: false)
                  flash[:success] = '勤怠時間を更新しました。なお本日以降の更新はできません。'
          end
      end 
    redirect_to user_url(@user, params:{first_day: params[:date]})
  end

  private
    def works_params
      params.permit(works: [:attendance_time, :leaving_time, :remarks, :change_request, :check_tomorrow, :attendance_after_chenge, :liaving_after_chenge])[:works]
    end

end