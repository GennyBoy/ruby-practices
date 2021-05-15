#!/usr/bin/env ruby
# frozen_string_literal: true

require 'minitest/autorun'
require './lib/ls'

class LsTest < Minitest::Test
  def test_ls_test_directory
    result = ls('./test/test_directory')
    expected = <<~TEXT.chomp
      A_test.txt          directory1          test_file.txt
      Z_directory         e_file.txt          x_test_file.rb
      b_directory         file.txt            z_test_file.txt
      bcd.txt             test_directory

    TEXT
    assert_equal expected, result
  end

  def test_ls_test_directory2
    result = ls('./test/test_directory2')
    expected = <<~TEXT.chomp
      A_test.txt          file.txt            test_directory
      Z_directory

    TEXT
    assert_equal expected, result
  end

  def test_ls_test_directory4
    result = ls('./test/test_directory4')
    expected = <<~TEXT.chomp
      A_test.txt          file.txt            test_directory

    TEXT
    assert_equal expected, result
  end

  def test_ls_all_test_directory
    result = ls('./test/test_directory', list_all_flag: true)
    expected = <<~TEXT.chomp
      .                   b_directory         test_directory
      ..                  bcd.txt             test_file.txt
      .hidden             directory1          x_test_file.rb
      A_test.txt          e_file.txt          z_test_file.txt
      Z_directory         file.txt

    TEXT
    assert_equal expected, result
  end

  def test_ls_all_test_directory2
    result = ls('./test/test_directory2', list_all_flag: true)
    expected = <<~TEXT.chomp
      .                   A_test.txt          test_directory
      ..                  Z_directory
      .hidden             file.txt

    TEXT
    assert_equal expected, result
  end

  def test_ls_all_test_directory3
    result = ls('./test/test_directory3', list_all_flag: true)
    expected = <<~TEXT.chomp
      .                   bcd.txt             test_directory
      ..                  directory1
      b_directory         e_file.txt

    TEXT
    assert_equal expected, result
  end

  def test_ls_reverse_test_directory
    result = ls('./test/test_directory', reverse_flag: true)
    expected = <<~TEXT.chomp
      z_test_file.txt     file.txt            b_directory
      x_test_file.rb      e_file.txt          Z_directory
      test_file.txt       directory1          A_test.txt
      test_directory      bcd.txt

    TEXT
    assert_equal expected, result
  end

  def test_ls_reverse_test_directory2
    result = ls('./test/test_directory2', reverse_flag: true)
    expected = <<~TEXT.chomp
      test_directory      Z_directory         A_test.txt
      file.txt

    TEXT
    assert_equal expected, result
  end

  def test_ls_reverse_test_directory3
    result = ls('./test/test_directory3', reverse_flag: true)
    expected = <<~TEXT.chomp
      test_directory      directory1          b_directory
      e_file.txt          bcd.txt

    TEXT
    assert_equal expected, result
  end

  def test_ls_reverse_test_directory4
    result = ls('./test/test_directory4', reverse_flag: true)
    expected = <<~TEXT.chomp
      test_directory      file.txt            A_test.txt

    TEXT
    assert_equal expected, result
  end

  def test_ls_all_reverse_test_directory
    result = ls('./test/test_directory', list_all_flag: true, reverse_flag: true)
    expected = <<~TEXT.chomp
      z_test_file.txt     e_file.txt          A_test.txt
      x_test_file.rb      directory1          .hidden
      test_file.txt       bcd.txt             ..
      test_directory      b_directory         .
      file.txt            Z_directory

    TEXT
    assert_equal expected, result
  end

  def test_ls_all_reverse_test_directory2
    result = ls('./test/test_directory2', list_all_flag: true, reverse_flag: true)
    expected = <<~TEXT.chomp
      test_directory      A_test.txt          .
      file.txt            .hidden
      Z_directory         ..

    TEXT
    assert_equal expected, result
  end

  def test_ls_long_test_directory
    result = ls('./test/test_directory', long_list_flag: true)
    expected = <<~TEXT.chomp
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
    assert_equal expected, result
  end

  def test_ls_all_long_test_directory2
    result = ls('./test/test_directory', list_all_flag: true, long_list_flag: true)
    expected = <<~TEXT.chomp
      drwxr-xr-x 14 kudogen  staff 448  5  2 16:29 ./
      drwxr-xr-x  7 kudogen  staff 224  5 15 09:50 ../
      -rw-r--r--  1 kudogen  staff   0  5  2 10:34 .hidden
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
    assert_equal expected, result
  end

  def test_ls_all_long_reverse_test_directory
    result = ls('./test/test_directory', list_all_flag: true, long_list_flag: true, reverse_flag: true)
    expected = <<~TEXT.chomp
      -rw-r--r--  1 kudogen  staff   0  5  2 16:29 z_test_file.txt
      -rw-r--r--  1 kudogen  staff   0  5  2 16:28 x_test_file.rb
      -rw-r--r--  1 kudogen  staff   0  5  2 16:27 test_file.txt
      drwxr-xr-x  2 kudogen  staff  64  4 26 21:55 test_directory/
      -rw-r--r--  1 kudogen  staff   0  4 26 21:56 file.txt
      -rw-r--r--  1 kudogen  staff   0  4 26 22:00 e_file.txt
      drwxr-xr-x  2 kudogen  staff  64  4 26 21:53 directory1/
      -rw-r--r--  1 kudogen  staff   0  4 28 18:21 bcd.txt
      drwxr-xr-x  2 kudogen  staff  64  4 26 21:53 b_directory/
      drwxr-xr-x  2 kudogen  staff  64  4 26 21:55 Z_directory/
      -rw-r--r--  1 kudogen  staff   0  4 26 21:56 A_test.txt
      -rw-r--r--  1 kudogen  staff   0  5  2 10:34 .hidden
      drwxr-xr-x  7 kudogen  staff 224  5 15 09:50 ../
      drwxr-xr-x 14 kudogen  staff 448  5  2 16:29 ./
    TEXT
    assert_equal expected, result
  end
end
