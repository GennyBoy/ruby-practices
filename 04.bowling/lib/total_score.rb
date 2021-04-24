#!/usr/bin/env ruby
# frozen_string_literal: true

def split_into_frames(scores)
  shots = []
  scores.split(',').each { |s| s == 'X' ? (shots.push 10, 0) : shots << s.to_i }

  frames = []
  shots.each_slice(2) { |s| frames << s }
  frames
end

def calculate_total_score(scores)
  frames = split_into_frames(scores)
  point = 0
  frames.each_with_index do |frame, i|
    point += frame.sum
    if frame[0] == 10 && i < 9 # strikeの場合
      point += frames[i + 1].sum
      point += frames[i + 2].first if frames[i + 1].first == 10 # strikeが2回続いたとき
    elsif frame.sum == 10 && i < 9 # spareの場合
      point += frames[i + 1].first
    end
  end
  point
end
