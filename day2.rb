# frozen_string_literal: true

games = File.open("input2.txt").readlines.map(&:chomp).map do |line|
  arr = line.split(': ')
  arr[0] =~ /Game (\d+)/
  game_id = $1.to_i
  sets = arr[1].split(';').map do |set|
    set.split(', ').map do |n_color|
      n, color = n_color.split(' ')
      [color, n.to_i]
    end.to_h
  end
  [game_id, sets]
end.to_h

def possible(set)
  max_colors = { 'red' => 12, 'green' => 13, 'blue' => 14  }
  colors = set.keys
  colors.map { |color| set[color] <= max_colors[color] }.all?
end

possible_games = games.select { |id, sets| sets.map {|set| possible(set)}.all? }
puts possible_games.keys.sum