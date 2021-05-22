#!/usr/bin/env ruby
# frozen_string_literal: true

require 'minitest/autorun'
require './lib/wc'

class WcTest < Minitest::Test
  def test_file_input_without_line_flag
    result = main("./test/fixtures/test.txt")
    expected = "       6      17     121 ./test/fixtures/test.txt"
    assert_equal expected, result
  end

  def test_file_input_with_line_flag
    result = main("./test/fixtures/test.txt", lines_flag: true)
    expected = "       6 ./test/fixtures/test.txt"
    assert_equal expected, result
  end
end
