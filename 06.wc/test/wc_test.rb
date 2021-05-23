#!/usr/bin/env ruby
# frozen_string_literal: true

require 'minitest/autorun'
require './lib/wc'

class WcTest < Minitest::Test
  TEST_FILE1 = './test/fixtures/test.txt'
  TEST_FILE2 = './test/fixtures/test2.txt'
  INPUT_TEXT = <<~TEXT
      total 0
      -rw-r--r--  1 kudogen  staff   0  4 26 21:56 A_test.txt
      drwxr-xr-x  2 kudogen  staff  64  4 26 21:55 Z_directory/
      drwxr-xr-x  2 kudogen  staff  64  4 26 21:53 b_directory/
      -rw-r--r--  1 kudogen  staff   0  4 28 18:21 bcd.txt
      drwxr-xr-x  2 kudogen  staff  64  4 26 21:53 directory1/
      -rw-r--r--  1 kudogen  staff   0  4 26 22:00 e_file.txt
      -rw-r--r--  1 kudogen  staff   0  4 26 21:56 file.txt
      drwxr-xr-x  2 kudogen  staff  64  4 26 21:55 test_directory/
      -rw-r--r--  1 kudogen  staff   0  5  2 16:27 test_file.txt
      -rw-r--r--  1 kudogen  staff   0  5  2 16:28 x_test_file.rb
      -rw-r--r--  1 kudogen  staff   0  5  2 16:29 z_test_file.txt
  TEXT

  def test_file_input_without_line_flag
    result = main([TEST_FILE1])
    expected = '       6      18     121 ./test/fixtures/test.txt'
    assert_equal expected, result
  end

  def test_file_input_with_line_flag
    result = main([TEST_FILE1], lines_flag: true)
    expected = '       6 ./test/fixtures/test.txt'
    assert_equal expected, result
  end

  def test_multiple_file_input_without_line_flag
    file_paths = [TEST_FILE1, TEST_FILE2]
    result = main(file_paths)
    expected = <<-TEXT.chomp
       6      18     121 ./test/fixtures/test.txt
       6      16      61 ./test/fixtures/test2.txt
      12      34     182 total
    TEXT
    assert_equal expected, result
  end

  def test_multiple_file_input_with_line_flag
    file_paths = [TEST_FILE1, TEST_FILE2]
    result = main(file_paths, lines_flag: true)
    expected = <<-TEXT.chomp
       6 ./test/fixtures/test.txt
       6 ./test/fixtures/test2.txt
      12 total
    TEXT
    assert_equal expected, result
  end

  def test_standard_input_without_line_flag
    $stdin = StringIO.new(INPUT_TEXT)
    result = main([])
    expected = '      12     101     641'
    assert_equal expected, result
  end

  def test_standard_input_with_line_flag
    $stdin = StringIO.new(INPUT_TEXT)
    result = main([], lines_flag: true)
    expected = '      12'
    assert_equal expected, result
  end
end
