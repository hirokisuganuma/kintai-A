require 'csv'

csv_column_names = ["日付","出社時間","退社時間","備考"]
CSV.generate(encoding: Encoding::SJIS, row_sep: "\r\n", force_quotes: true) do |csv|
    csv << csv_column_names
        @works.each do |work|
            csv_column_values = [
                work.day,
                if work.attendance_time
                    work.attendance_time.strftime("%R")
                end,
                if work.leaving_time
                    work.leaving_time.strftime("%R")
                end,
                work.remarks,
                ]
            csv << csv_column_values
        end
end