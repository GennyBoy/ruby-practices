#!/usr/bin/env ruby
require 'date'
require 'optparse'

params = ARGV.getopts("m:", "y:")
specified_month = params['m']
specified_year = params['y']

# short_optにはデフォルト値を設定できないので、
# nilの(引数が渡されなかった)場合に今月の年月を設定する
if specified_year == nil
  YEAR = Date.today.year
elsif specified_year.to_i >= 1 && specified_year.to_i <= 9999
  YEAR = specified_year.to_i
else
  puts "cal: year '#{specified_year}' not in range 1..9999"
  exit
end

if specified_month == nil
  MONTH = Date.today.month
elsif specified_month.to_i >= 1 && specified_month.to_i <= 12
  MONTH = specified_month.to_i
else
  puts "cal: #{specified_month} is neither a month number (1..12) nor a name"
  exit
end


START_DATE = Date.new(YEAR, MONTH, 1)
END_DATE = Date.new(YEAR, MONTH, -1)
END_DAY = END_DATE.day

# 指定された年月日が、現在の年月かを判定するメソッド
def is_today?(year, month, day)
  today_date = Date.today
  return true if year == today_date.year && month == today_date.month && day == today_date.day
end

# 曜日を判定して、曜日に応じた値(int)を返すメソッド
def which_day(date)
  if date.sunday?
    0
  elsif date.monday?
    1
  elsif date.tuesday?
    2
  elsif date.wednesday?
    3
  elsif date.thursday?
    4
  elsif date.friday?
    5
  elsif date.saturday?
    6
  end
end

puts "   　　#{MONTH}月 #{YEAR}"
puts " 日 月 火 水 木 金 土"

day = 0
week = 1
while day <= END_DAY
  i = 0
  if week == 1
    which_day(START_DATE).times { print "   " }
    i = which_day(START_DATE)
  end
  while i < 7
    day = day + 1
    if day <= END_DAY
      # 日付が１桁か２桁かでスペースの数を調整
      if day < 10
        # 今日の日付であれば、背景色と文字色を反転させる
        if is_today?(YEAR, MONTH, day)
          print " " + "\e[7m #{day.to_s}\e[0m"
        else
          print "  " + day.to_s
        end
      else
        # 今日の日付であれば、背景色と文字色を反転させる
        if is_today?(YEAR, MONTH, day)
          print "\e[7m #{day.to_s}\e[0m"
        else
          print " " + day.to_s
        end
      end
      break if day == END_DAY
      i = i + 1
    end
  end
  print "\n"
  week = week + 1
  break if day == END_DAY
end
