#!/usr/bin/env ruby
# frozen_string_literal: true

require './lib/total_score'

score = ARGV[0]
puts calculate_total_score(score)
