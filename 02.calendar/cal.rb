#!/usr/bin/env ruby
require 'date'
require 'optparse'

params = ARGV.getopts("m:", "y:")

# short_optにはデフォルト値を設定できないので、
# nilの(引数が渡されなかった)場合に今月の年月を設定する
year = params['y'].to_i || Date.today.year
month = params['m'].to_i || Date.today.month

START_DATE = Date.new(year, month, 1)
END_DATE = Date.new(year, month, -1)
END_DAY = END_DATE.day

# 指定された年月日が、現在の年月かを判定するメソッド
def today?(year, month, day)
  today_date = Date.today
  year == today_date.year && month == today_date.month && day == today_date.day
end

puts "   　　#{month}月 #{year}"
puts " 日 月 火 水 木 金 土"

START_DATE.wday.times { print "   " }
(START_DATE..END_DATE).each do |date|
  # 月の開始の曜日によってスペースの数を調整
  day = date.day
  # 日付が１桁か２桁かでスペースの数を調整
  if day < 10
    # 今日の日付であれば、背景色と文字色を反転させる
    if date == Date.today
      print " " + "\e[7m #{day.to_s}\e[0m"
    else
      print "  " + day.to_s
    end
  else
    # 今日の日付であれば、背景色と文字色を反転させる
    if date == Date.today
      print "\e[7m #{day.to_s}\e[0m"
    else
      print " " + day.to_s
    end
  end
  print "\n" if date.saturday?
end
print "\n\n"
