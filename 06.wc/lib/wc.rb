#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

def main(file_paths, lines_flag: false)
  if file_paths.empty?
    stdin = $stdin.read
    build_columns(resolve_lines_size(stdin), resolve_words_size(stdin), resolve_bytesize(stdin), lines_flag)
      .map! { |item| item.to_s.rjust(8) }
      .join
  else
    build_output_from_file(file_paths, lines_flag)
  end
end

def build_output_from_file(file_paths, lines_flag)
  lines_to_display = []

  file_paths.each { |file_path| lines_to_display << "#{build_line(file_path, lines_flag)}\n" }

  # 複数ファイルが渡されたときは合計値を表示する
  lines_to_display << build_total_line(file_paths, lines_flag) unless file_paths.size == 1

  lines_to_display.join.chomp
end

def build_line(file_path, lines_flag)
  file_content = File.read(file_path)
  input_path = " #{file_path}"

  build_columns(
    resolve_lines_size(file_content),
    resolve_words_size(file_content),
    resolve_bytesize(file_content),
    lines_flag,
    file_name: input_path
  )
    .map! { |item| item.to_s.rjust(8) }
    .join
end

def build_total_line(file_paths, lines_flag)
  total_lines_size = 0
  total_words_size = 0
  total_bytes_size = 0
  file_paths.each do |file_path|
    file_content = File.read(file_path)
    total_lines_size += resolve_lines_size(file_content)
    total_words_size += resolve_words_size(file_content)
    total_bytes_size += resolve_bytesize(file_content)
  end

  total = build_columns(total_lines_size, total_words_size, total_bytes_size, lines_flag)
          .map { |item| item.to_s.rjust(8) }
  total << ' total'
  total.join
end

def build_columns(lines_size, words_size, bytes_size, lines_flag, file_name: nil)
  columns = []
  columns << lines_size
  columns.push(words_size, bytes_size) unless lines_flag
  columns.push file_name if file_name
  columns
end

def resolve_bytesize(file_content)
  file_content.bytesize
end

def resolve_lines_size(file_content)
  split_by_new_line(file_content).size
end

def resolve_words_size(file_content)
  words = []
  # [[:blank:]]+ スペースとタブ が1文字以上続くところでsplit
  split_by_new_line(file_content).each { |line| words << line.split(/[[:blank:]]+/) }
  words.flatten.size
end

def split_by_new_line(file_content)
  file_content.split("\n")
end

if __FILE__ == $PROGRAM_NAME
  opt = OptionParser.new

  lines_option = false
  opt.on('-l') { lines_option = true }
  opt.parse!

  file_paths = ARGV
  puts main(file_paths, lines_flag: lines_option)
end
