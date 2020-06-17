class Game
  include PlayingCards

  def initialize
    @scoresheet = blackjack_scoresheet
  end

  def start_game
    sign_in
    print "Enter number of decks: "
    @deck = Deck.new(gets.chomp.to_i)
    @dealer = Dealer.new('Dealer')
    start_round
  end

  def sign_in
    print 'Enter your name: '
    @player = Player.new(gets.chomp)
  end

  def deal_card
    @deck.deal_card
  end

  def hand_score(player)
    score = player.hand.reduce(0) { |sum, card| sum + @scoresheet[card] }
    player.hand.select { |c| c.include?('A') }.each { score -= 10 if score > 21 }
    score
  end

  private

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
    return unless @deck.cards_in_deck > 5

    self.information = "Round Started"
    @player.hand_clear
    @dealer.hand_clear
    puts show_table
    call
  end

  def show_table
    "#{@deck.cards_in_deck} cards in deck | #{information}\n" +
      "#{@player.name}, (#{hand_score(@player)})\n" +
      "| #{@player.hand.join(' | ')} |\n" +
      "#{@dealer.name}\n" +
      "| #{@dealer.hand.map { '*' }.join(' | ')} |"
  end

  def interface
    puts "Your action:"
    %w[
      Stand
      Hit
      Open\ cards
    ].each.with_index(1) do |opt, index|
      puts "#{index}. #{opt}"
    end
  end

  def process_input(input)
    case input.to_i
    when 1
      stand
    when 2
      hit
    when 3
      stop_round
    else
      wrong_choise
    end
  end

  def call
    loop do
      interface
      input = gets.chomp.strip
      break if input.downcase == 'exit'

      process_input(input)
      break if input.to_i == 3
    end
  end

  def stand
    @dealer.move(self)
    self.information = "Stand, Dealer's move"
    puts show_table
  end

  def hit
    @dealer.deal(@player, self)
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
    "#{@player.name}, (#{hand_score(@player)}), | #{@player.hand.join(' | ')} |\n" +
      "#{@dealer.name}, (#{hand_score(@dealer)}), | #{@dealer.hand.join(' | ')} |"
  end

  def winner
    if hand_score(@player) < 22 && (hand_score(@player) > hand_score(@dealer) || hand_score(@dealer) > 21)
      'You win'
    elsif hand_score(@player) == hand_score(@dealer)
      'Draw'
    else
      'Dealer win'
    end
  end
end
