# frozen_string_literal: true

games = File.open("input2.txt").readlines.map(&:chomp).map do |line|
  arr = line.split(': ')
  sets = arr[1].split(';').map do |set|
    set.split(', ').map do |n_color|
      n, color = n_color.split(' ')
      [color, n.to_i]
    end.to_h
  end
  sets
end

mins = games.map do |sets|
  sets.inject do |acc, set|
    acc.merge(set) do |key, oldval, newval|
      [oldval, newval].max
    end
  end
end

powers = mins.map { |min| min.values.reduce(:*) }

puts powers.sum
