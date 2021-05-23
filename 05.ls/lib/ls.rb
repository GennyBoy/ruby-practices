#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'date'
require 'etc'

def main(dir, columns_size: 3, list_all_flag: false, reverse_flag: false, long_list_flag: false)
  specified_dir = dir || File.absolute_path('.')

  list, blocks_total = create_list(specified_dir, list_all_flag, reverse_flag, long_list_flag)

  if long_list_flag
    list.unshift("total #{blocks_total}")
    list.join("\n")
  else
    # より良いメソッド名があれば変えたい
    convert_list_without_long_option_to_str(list, columns_size)
  end
end

def create_list(path, list_all_flag, reverse_flag, long_list_flag)
  # File::FNM_DOTMATCH : 隠しファイルも含める
  # 0 : デフォルト値(フラグ指定なし = 隠しファイルを含めない)
  flags = list_all_flag ? File::FNM_DOTMATCH : 0

  sorted_file_path_list = Dir.glob("#{path}/*", flags).sort

  blocks_total = 0
  sorted_file_path_list.each { |item| blocks_total += File.stat(item).blocks }

  list =
    if long_list_flag
      create_long_list(sorted_file_path_list)
    else
      sorted_file_path_list.map { |item| setup_basename(item) }
    end

  list.reverse! if reverse_flag
  [list, blocks_total]
end

def create_long_list(list)
  lines = []

  list.each do |item|
    lines << create_rows_with_long_option(item)
  end
  lines
end

def convert_list_without_long_option_to_str(list, columns_size)
  rows_size = (list.size / columns_size.to_f).ceil
  str = ''
  create_rows_without_long_option(columns_size, rows_size, list).each do |row|
    row.each { |file| str += file&.ljust(20) || '' }
    str = "#{str.rstrip}\n"
  end
  str
end

def create_rows_without_long_option(columns_size, rows_size, list)
  rows = Array.new(rows_size) { [] }
  index = 0
  list.size.times do
    index = 0 if index == rows_size
    if list.size == columns_size - rows.first.size
      rows.first << list.shift
    else
      rows[index] << list.shift
    end
    index += 1
  end
  rows
end

def create_rows_with_long_option(item)
  line = []

  fs = File.stat(item)
  last_updated = fs.mtime

  # 必要かどうか迷ったが、説明変数としてあったほうが理解しやすいかなと考え一旦変数に入れた
  hardlink_size = fs.nlink.to_s.rjust(2)
  file_owner = Etc.getpwuid(fs.uid).name.rjust(6)
  file_owner_group = Etc.getgrgid(fs.gid).name.rjust(6)
  file_size = fs.size.to_s.rjust(3)
  last_updated_month = last_updated.strftime('%m').tr('0', ' ')
  last_updated_day = last_updated.strftime('%e')

  # 関数と変数入り混じってるの気持ち悪いかも…？
  # 必要だったら修正する
  line.push setup_entry_type_and_permissions(fs),
            hardlink_size,
            file_owner,
            file_owner_group,
            file_size,
            last_updated_month,
            last_updated_day,
            setup_last_update_hour(last_updated),
            setup_basename(item)

  line.join(' ')
end

def setup_entry_type_and_permissions(file_stat_object)
  entry_type_and_permissions = [convert_file_type_to_mode(file_stat_object.ftype)]

  permissions_in_octal = file_stat_object.mode.to_s(8).slice(-3, 3)

  entry_type_and_permissions +=
    Array.new(3) do |n|
      convert_permission_octal_to_characters(permissions_in_octal.slice(n)).to_s
    end
  entry_type_and_permissions.join
end

def setup_last_update_hour(last_update_date)
  # 今年でない場合は、年を表示する
  # 本当のlsコマンドの仕様では半年以上前からだと、年が表示されるようになる
  if last_update_date.year == Date.today.year
    last_update_date.strftime('%R')
  else
    last_update_date.year
  end
end

def setup_basename(file)
  if File.stat(file).ftype == 'directory'
    File.basename(file).concat('/')
  else
    File.basename(file)
  end
end

def convert_file_type_to_mode(ftype)
  {
    'file' => '-',
    'directory' => 'd',
    'link' => 'l'
  }[ftype]
end

def convert_permission_octal_to_characters(permission_in_octal)
  {
    '0' => '---',
    '1' => '--x',
    '2' => '-w-',
    '3' => '-wx',
    '4' => 'r--',
    '5' => 'r-x',
    '6' => 'rw-',
    '7' => 'rwx'
  }[permission_in_octal]
end

if __FILE__ == $PROGRAM_NAME
  COLUMNS_SIZE = 3 # -lがないときの表示列数。変更するときは、この定数を書き換える。
  list_all_flag = false
  reverse_flag = false
  long_list_flag = false

  ARGV.options do |opt|
    opt.on('-a') { list_all_flag = true }
    opt.on('-r') { reverse_flag = true }
    opt.on('-l') { long_list_flag = true }
    opt.parse!
  end
  path = ARGV[0]
  puts main(path, columns_size: COLUMNS_SIZE, list_all_flag: list_all_flag, reverse_flag: reverse_flag, long_list_flag: long_list_flag)
end
