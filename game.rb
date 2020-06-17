class Game
  include PlayingCards

  def initialize
    @scoresheet = blackjack_scoresheet
    @staff_names = %w[John Mike Kate Cindy]
  end

  def call
    sign_in
    prepare_deck
    assign_dealer
    start_round
  end

  def sign_in
    print 'Enter your name: '
    @player = Player.new(gets.chomp)
  end

  def prepare_deck
    print "Enter number of decks: "
    input = gets.chomp.to_i
    input = 1 unless (1..8).include?(input)

    @deck = Deck.new(input)
  end

  def assign_dealer
    @dealer = Dealer.new("Dealer #{staff_names.sample}")
  end

  def deal_card
    deck.deal_card
  end

  def hand_score(player)
    score = player.hand.reduce(0) { |sum, card| sum + scoresheet[card] }
    player.hand.select { |c| c.include?('A') }.each { score -= 10 if score > 21 }
    score
  end

  private

  attr_reader :player, :dealer, :deck, :scoresheet, :staff_names
  attr_accessor :information

  def blackjack_scoresheet
    suits.inject({}) do |hash, suit|
      ranks.each do |rank|
        case rank
        when 'A'
          hash["#{rank}#{suit}"] = 11
        when 'K', 'Q', 'J'
          hash["#{rank}#{suit}"] = 10
        else
          hash["#{rank}#{suit}"] = rank.to_i
        end
      end
      hash
    end
  end

  def start_round
    return unless deck.cards_in_deck > 5

    self.information = "Round Started"
    player.hand_clear
    dealer.hand_clear
    2.times do
      initial_deal
      puts show_table
    end
    stand if rand(2).zero?
    menu
  end

  def initial_deal
    puts "Dealing cards..."
    sleep(2)
    dealer.deal(player, self)
    dealer.move(self)
  end

  def show_table
    "#{deck.cards_in_deck} cards in deck | #{information}\n" +
      "#{player.name}, (#{hand_score(player)})\n" +
      "| #{player.hand.join(' | ')} |\n" +
      "#{dealer.name}\n" +
      "| #{dealer.hand.map { '*' }.join(' | ')} |"
  end

  def interface
    %w[
      ===============
      1\ Stand
      2\ Hit
      3\ Open\ cards
      Exit
    ].each { |opt| puts opt }
  end

  def process_input(input)
    case input.to_i
    when 1
      stand
    when 2
      hit
      stand
    when 3
      stop_round
    else
      wrong_choise
    end
  end

  def menu
    loop do
      interface
      print "Your action: "
      input = gets.chomp.strip
      break if input.downcase == 'exit'

      process_input(input)
      break if input.to_i == 3
    end
  end

  def stand
    sleep(1)
    dealer.move(self)
    self.information = "Dealer's move"
    puts show_table
  end

  def hit
    dealer.deal(player, self)
    self.information = "Hit"
    puts show_table
  end

  def stop_round
    self.information = "Round ended"
    puts show_table
    puts show_score
    puts winner
    puts 'Again? (Y/N)'
    start_round if gets.chomp.upcase == 'Y'
  end

  def wrong_choise
    self.information = 'Whrong choice'
    puts show_table
  end

  def show_score
    "#{player.name}, (#{hand_score(player)}), | #{player.hand.join(' | ')} |\n" +
      "#{dealer.name}, (#{hand_score(dealer)}), | #{dealer.hand.join(' | ')} |"
  end

  def winner
    if hand_score(player) < 22 && (hand_score(player) > hand_score(dealer) || hand_score(dealer) > 21)
      "#{player.name} win!"
    elsif hand_score(player) == hand_score(dealer)
      'Draw'
    else
      "#{dealer.name} win!"
    end
  end
end
