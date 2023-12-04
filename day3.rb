SYMBOL = /\*|\@|\#|\-|\=|\/|\+|\%|\$|\&/
GEAR = /\*/

def regex_positions(string, regex)
  string.enum_for(:scan, regex).map { Regexp.last_match.begin(0) }
end

$lines = File.open("input3.txt").readlines.map(&:chomp)

numbered_lines = (0..$lines.length - 1).zip $lines

gear_coordinates = numbered_lines.flat_map do |line_no, line|
  regex_positions(line, SYMBOL).map do |gear_position|
    [line_no, gear_position]
  end
end

symbol_coordinates = numbered_lines.flat_map do |line_no, line|
  regex_positions(line, SYMBOL).map do |symbol_position|
    [line_no, symbol_position]
  end
end

$grid = $lines.map do |line|
  line.split ''
end

def on_grid?(c)
  height = $grid.length
  width = $grid[0].length
  0 <= c[0] && c[0] <= height - 1 &&
    0 <= c[1] && c[1] <= width - 1
end

def adjacent_coordinates(coordinate)
  l = coordinate[0] # line number
  r = coordinate[1] # row position

  [[l-1, r-1], [l-1, r], [l-1, r+1],
   [l,   r-1],           [l,   r+1],
   [l+1, r-1], [l+1, r], [l+1, r+1]].select { |l, r| on_grid?([l, r])}
end

def adjacent_digit_coords(coordinate)
  adjacent_coordinates(coordinate).select do |l, r|
    $grid[l][r] =~ /\d/
  end
end

def start_pos_of_code_at(l, r)
  while on_grid?([l, r - 1]) \
    && $grid[l][r - 1] =~ /\d/
    r = r - 1
  end
  [l, r]
end

def code_at(l, r)
  $lines[l].slice(r..)[/\d+/]
end

def adjacent_codes_with_coords(coordinate)
  adjacent_digit_coords(coordinate).map do |l, r|
    l, r = start_pos_of_code_at(l, r)
    [[l, r], code_at(l, r)]
  end.to_h.to_a
end

two_part_gear_coordinates = gear_coordinates.select do |l, r|
  adjacent_codes_with_coords([l, r]).length == 2
end

part2_total = two_part_gear_coordinates.map do |l, r|
  adjacent_codes_with_coords([l, r]).reduce(1) do |acc, code|
    acc * code[1].to_i
  end
end.sum


code_coordinates = symbol_coordinates.flat_map do |coordinate|
  adjacent_codes_with_coords(coordinate)
end.to_h

part1_total = code_coordinates.values.map(&:to_i).sum
puts part1_total, part2_total
