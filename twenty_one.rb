CARDS = [2, 3, 4, 5, 6, 7, 8, 9, 10, 'J', 'Q', 'K', 'A']
CARD_VALUE = { 2 => 2, 3 => 3, 4 => 4, 5 => 5,
               6 => 6, 7 => 7, 8 => 8, 9 => 9,
               10 => 10, 'J' => 10, 'Q' => 10, 'K' => 10 }

def prompt(msg)
  print "=> #{msg}"
end

def initial_deck
  deck = []
  4.times { deck << CARDS.shuffle }
  deck.flatten.shuffle
end

def initial_deal!(dealer_cards, player_cards, deck)
  2.times do
    dealer_cards << deck.shift
    player_cards << deck.shift
  end
end

def display_cards(dealer_cards, player_cards, option='')
  if option != 'all'
    prompt "Dealer: #{dealer_cards[0]}, <hidden>\n"
    prompt "Player: #{player_cards.join(', ')}\n"
  else
    prompt "Dealer: #{dealer_cards.join(', ')}\n"
    prompt "Player: #{player_cards.join(', ')}\n"
  end
end

def hit_player!(player_cards, deck)
  player_cards << deck.shift
end

def hit_dealer!(dealer_cards, deck)
  loop do
    dealer_cards << deck.shift
    break if cards_value(dealer_cards) >= 17
  end
end

def cards_value(cards)
  total = 0
  cards.each do |card|
    if card == 'A'
      total += 11
    else
      total += CARD_VALUE[card]
    end
  end
  
  cards.select { |card| card == 'A' }.count.times do
    total -= 10 if total >= 21
  end
  
  total
end

def busted?(player_cards)
  cards_value(player_cards) > 21
end

def display_result(dealer_cards, player_cards)
  player_total = cards_value(player_cards)
  dealer_total = cards_value(dealer_cards)
  
  prompt "[Final Score] Dealer: #{dealer_total} | Player: #{player_total}\n"

  if player_total == dealer_total
    prompt "Its a draw!\n"
  elsif player_total > dealer_total
    prompt busted?(player_cards) ? "The player busted!\n" : "The player won!\n"
  else
    prompt busted?(dealer_cards) ? "The dealer busted!\n" : "The dealer won!\n"
  end
end

prompt "Welcome to Twenty-One!\n"

loop do
  dealer_cards = []
  player_cards = []
  deck = initial_deck
  initial_deal!(dealer_cards, player_cards, deck)

  loop do
    answer = nil

    display_cards(dealer_cards, player_cards)

    loop do
      prompt "hit or stay? "
      answer = gets.chomp
      break if answer.downcase.start_with?('h', 's')
      prompt "Invalid response.\n"
    end

    if answer.start_with?('h')
      hit_player!(player_cards, deck)
      break if busted?(player_cards)
    else
      break
    end
  end

  hit_dealer!(dealer_cards, deck) if !busted?(player_cards)

  display_cards(dealer_cards, player_cards, 'all')
  display_result(dealer_cards, player_cards)

  answer = nil
  loop do
    prompt "Play again? (y/n)> "
    answer = gets.chomp
    break if answer.downcase.start_with?('y', 'n')
    prompt "Invalid response.\n"
  end

  break if answer.downcase.start_with?('n')
end

prompt "See you later!\n"
