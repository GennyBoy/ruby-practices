#!/usr/bin/env ruby
# frozen_string_literal: true

require 'date'
require 'optparse'

params = ARGV.getopts('m:', 'y:')

# short_optにはデフォルト値を設定できないので、
# nilの(引数が渡されなかった)場合に今月の年月を設定する
year = params['y']&.to_i || Date.today.year
month = params['m']&.to_i || Date.today.month

START_DATE = Date.new(year, month, 1)
END_DATE = Date.new(year, month, -1)

puts "   　　#{month}月 #{year}"
puts '日 月 火 水 木 金 土'

print '   ' * START_DATE.wday
(START_DATE..END_DATE).each do |date|
  day = date.day.to_s
  # 今日の日付であれば、背景色と文字色を反転させる
  if date == Date.today
    print "\e[7m#{day.rjust(2)}\e[0m"
  else
    print day.rjust(2)
  end
  print ' '
  print "\n" if date.saturday?
end
print "\n"
