
def parse(line)
  _, numbers = line.split(':')
  winning, mine = numbers.split('|').map do |part|
    Set.new(part.split(' '))
  end
end

cards = File.open('input4.txt').readlines.map(&:chomp)

total = cards.map do |line|
  winning, mine = parse(line)
  n_wins = winning.intersection(mine).length
  n_wins > 0 ? 2 ** (winning.intersection(mine).length - 1) : 0
end.sum

puts total