
def parse(line)
  card, numbers = line.split(':')
  card_no = card[/\d+/].to_i
  winning, mine = numbers.split('|').map do |part|
    Set.new(part.split(' '))
  end
  [card_no, winning.intersection(mine).length]
end

cards = File.open('input4.txt').readlines.map(&:chomp)

$win_counts = cards.map do |line|
  parse(line)
end.to_h

$card_counts = $win_counts.map do |card_no, wins|
  [card_no, 1]
end.to_h

$to_process = $win_counts.map { |card_no, _| card_no }

def add_wins(card_no)
  no_cards_won = $win_counts[card_no]
  if no_cards_won > 0
    from = card_no + 1
    to = [card_no + no_cards_won, $to_process.last].min
    (from..to).each { |c| $card_counts[c] = $card_counts[c] + $card_counts[card_no] }
  end
end

while $to_process.length > 0
  add_wins($to_process[0])
  $to_process = $to_process.drop(1)
end

puts $card_counts.values.sum
