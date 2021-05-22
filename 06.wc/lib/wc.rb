#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

# 終了条件
# -lオプションも実装すること。
# 標準入力からも受け取れるようにして実行結果と出力を提出する。
# 引数にファイル名が複数個来た場合にも対応し実行結果と出力を提出する。
# 本物の wc コマンドはノーブレークスペースを含むマルチバイト文字を1単語多くカウントするが、
# 自作の wc コマンドでは対応しなくても良い。
#
# 特殊な入力ケースに対応する必要はありません(例: 単語の区切りの空白文字は全角/半角スペース、タブ、改行程度で大丈夫です)。
#
# The wc utility displays the number of lines, words, and bytes contained in each input file, or
#      standard input (if no file is specified) to the standard output.  A line is defined as a
#      string of characters delimited by a <newline> character.  Characters beyond the final
#      <newline> character will not be included in the line count.
#
#      A word is defined as a string of characters delimited by white space characters.  White space
#      characters are the set of characters for which the iswspace(3) function returns true.  If more
#      than one input file is specified, a line of cumulative counts for all the files is displayed
#      on a separate line after the output for the last file.
#
# -l      The number of lines in each input file is written to the standard output.
#
#
# 行数、words, bytes
# -l がつくと行数とファイル名

# 引数ターゲットは後で見直す
def main(inputs, lines_flag: false)
  # targetがファイルかどうかで分岐
  # ファイルの場合
  #   ファイルのbytesを取る
  #   入力されたpathを取る
  #   targetに出力結果を入れる
  # targetのbytesを取る
  # targetを改行でsplitする => array.size => 行数
  # 全角/半角スペース、タブでsplit => array.size => words
  #
  # 渡されたものがファイルである前提に立つ
  if inputs.empty?
    stdin = $stdin.read
    numbers = setup_numbers_for_stdin(stdin)
    numbers.map! do |item|
      item.to_s.rjust(8)
    end
    numbers.join
  elsif inputs.size == 1
    setup_line_to_display(inputs[0], lines_flag)
  else
    when_more_than_one_file(inputs, lines_flag)
  end
end

def when_more_than_one_file(file_paths, lines_flag)
  lines_to_display = Array.new
  total_lines_size = 0
  total_words_size = 0
  total_bytes_size = 0
  file_paths.each_with_index do |file_path, i|
    total_lines_size += file_lines_size(file_path)
    total_words_size += file_words_size(file_path)
    total_bytes_size += file_bytes_size(file_path)
    lines_to_display <<
      if i != -1
        setup_line_to_display(file_path, lines_flag) + "\n"
      else
        setup_line_to_display(file_path, lines_flag)
      end
  end
  # total = [total_lines_size, total_words_size, total_bytes_size].map(&:to_s)
  # total.map! { |item| item.rjust(8) }
  # total << ' total'
  # lines_to_display << total.join
  lines_to_display << setup_total_line_to_display(lines_flag, total_lines_size, total_words_size, total_bytes_size)
  lines_to_display.join
end

def setup_total_line_to_display(lines_flag, total_lines_size, total_words_size, total_bytes_size)
  if lines_flag
    total = [total_lines_size].map(&:to_s)
  else
    total = [total_lines_size, total_words_size, total_bytes_size].map(&:to_s)
  end
  total.map! { |item| item.rjust(8) }
  total << ' total'
  total.join
end

def setup_numbers_files(file_path)
  bytes_size = File.size(file_path).to_s.rjust(8)
  lines = split_into_lines(file_path)
  lines_size = lines.size.to_s.rjust(8)

  words = split_into_words(lines)
  words_size = words.flatten.size.to_s.rjust(8)

  return bytes_size, lines_size, words_size
end

def setup_numbers_for_stdin(stdin)
  bytes_size = stdin.bytesize
  lines = stdin.split("\n")
  lines_size = lines.size
  words = split_into_words(lines)
  words_size = words.flatten.size

  return lines_size, words_size, bytes_size
end

def setup_line_to_display(file_path, lines_flag)
  input_path = ' ' + file_path
  bytes_size, lines_size, words_size = setup_numbers_files(file_path)
  # bytes = File.size(file_path).to_s.rjust(8)
  # lines = split_into_lines(file_path)
  # lines_size = lines.size.to_s.rjust(8)
  #
  # words = split_into_words(lines)
  # words_size = words.flatten.size.to_s.rjust(8)

  if lines_flag
    [lines_size, input_path].join
  else
    [lines_size, words_size, bytes_size, input_path].join
  end
end

def file_bytes_size(file_path)
  File.size(file_path)
end

def file_lines_size(file_path)
  split_into_lines(file_path).size
end

def file_words_size(file_path)
  split_into_words(split_into_lines(file_path)).flatten.size
end

def split_into_lines(file_path)
  File.open(file_path) { |f| f.readlines(chomp: true) }
end

def split_into_words(lines)
  words = Array.new
  lines.each do |line|
    # [[:blank:]]+ スペースとタブ が1文字以上続く
    words << line.split(/[[:blank:]]+/)
  end
  words
end

if __FILE__ == $PROGRAM_NAME
  opt = OptionParser.new

  lines_option = false
  opt.on('-l') { lines_option = true }
  opt.parse!

  inputs = ARGV
  puts main(inputs, lines_flag: lines_option)
end
