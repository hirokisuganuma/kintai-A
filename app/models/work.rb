class Work < ApplicationRecord
  belongs_to :user
  has_many :work_rogs
  validates :day,  presence: true
  validate :leaving_time_should_existence_attendance_time
  validate :leaving_time_should_early_attendance_time
  
  def leaving_time_should_existence_attendance_time
    if attendance_time.nil?
    errors.add(:leaving_time, ": 出社時間が存在していません。")
    end
  end

  def leaving_time_should_early_attendance_time #未来を表す時刻が大きい
    if attendance_time.to_s > leaving_time.to_s
    errors.add(:leaving_time, ": 出社時間より退社時間が早い項目がありました")
    end
  end
end
