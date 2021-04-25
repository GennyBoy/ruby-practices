#!/usr/bin/env ruby
# frozen_string_literal: true

require 'minitest/autorun'
require './lib/total_score'

class BowlingTest < Minitest::Test
  def test_calculate_total_core
    assert_equal 139, calculate_total_score('6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,6,4,5')
    assert_equal 164, calculate_total_score('6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,X,X')
    assert_equal 107, calculate_total_score('0,10,1,5,0,0,0,0,X,X,X,5,1,8,1,0,4')
    assert_equal 134, calculate_total_score('6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,0,0')
    assert_equal 300, calculate_total_score('X,X,X,X,X,X,X,X,X,X,X,X')
  end
end
