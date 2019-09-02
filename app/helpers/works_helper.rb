module WorksHelper

  def select_user
    @user = User.find(params[:id])
  end

  def current_time
    Time.new(
      Time.now.year,
      Time.now.month,
      Time.now.day,
      Time.now.hour,
      Time.now.min, 0
    ).round_to(15.minutes)
  end

  def time_change(day, time)
    day=day.to_datetime
    time=time.to_datetime
    Time.new(day.year,day.month,day.day,time.hour,time.min,time.sec)
  end
  
  def overwork_time(over_work)
    a=over_work.day
    a_1=over_work.over_time_end
    b=select_user.end_time
    c=Time.new(a.year,a.month,a.day,b.hour,b.min,b.sec)
    d=Time.new(a_1.year,a_1.month,a_1.day,a_1.hour,a_1.min,a_1.sec)
    (d-c)/60/60
  end

  def over_check(work)
    if work
      work && work.over_time_request
      if work.over_time_request=="上長１" || work.over_time_request=="上長2" || work.over_time_request=="上長3"
        "残業を#{work.over_time_request}に申請中"
      elsif work.over_time_request=="否認"
        "残業否認"
      elsif work.over_time_request=="承認"
        "残業承認済"
      end
    end
  end

  def month_check_window(works)
      day = works.day.beginning_of_month
    if current_user.works.find_by(day: day).nil? || current_user.works.find_by(day: day).month_request.nil?
      "未"
    else
      current_user.works.find_by(day: day).month_request
    end
  end

  def work_check(work)
    if work
      work && work.change_request
      if work.change_request=="上長１" || work.change_request=="上長2" || work.change_request=="上長3"
        "勤怠変更を#{work.change_request}に申請中"
      elsif work.change_request=="否認"
        "勤怠変更否認"
      elsif work.change_request=="承認"
        "勤怠変更承認済"
      end
    end
  end

  def working_times(started_at, finished_at)
    format("%.2f", (((finished_at - started_at) / 60) / 60.0))
  end

  def working_times_sum(seconds)
    format("%.2f", seconds / 60 / 60.0)
  end
  
  def works_invalid?
    works = true
    works_params.each do |id, item|
      if item[:attendance_time].blank? && item[:leaving_time].blank?
        next
      elsif item[:attendance_time].blank? || item[:leaving_time].blank?
        works = false
        break
      elsif item[:attendance_time] > item[:leaving_time]
        works = false
        break
      end
    end
    return works
  end
end
