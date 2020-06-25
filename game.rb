class Game
  def call
    @deck = Deck.new
    @scoresheet = deck.scoresheet
    @dealer = Dealer.new(scoresheet: scoresheet)
    sign_in
    start
  end

  private

  attr_reader :user, :dealer, :deck, :scoresheet
  attr_accessor :message

  def sign_in
    print 'Enter your name: '
    name = gets.chomp
    @user = User.new(name: name.strip, scoresheet: scoresheet)
  end

  def start
    self.message = "Game Started"
    2.times do
      initial_deal
    end
    puts table
    pass if rand(2).zero?
    menu
  end

  def initial_deal
    puts "Dealing cards..."
    sleep(2)
    user.deal(deck.deal_card)
    dealer.deal(deck.deal_card)
  end

  def table
    "#{deck.deck.size} cards in deck | #{message}\n" +
      "#{user.name}, (#{user.score})\n" +
      "| #{user.cards.join(' | ')} |\n" +
      "#{dealer.name}\n" +
      "| #{dealer.cards.map { '*' }.join(' | ')} |"
  end

  def interface
    %w[
      ===============
      1\ Pass
      2\ Hit
      3\ Open\ cards
      Exit
    ].each { |opt| puts opt }
  end

  def process_input(input)
    case input.to_i
    when 1
      pass
    when 2
      hit
      pass
    when 3
      stop
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

  def pass
    sleep(1)
    dealer.deal(deck.deal_card) if dealer.cards.size < 3 && dealer.score < 17

    self.message = "Dealer's move"
    puts table
  end

  def hit
    user.deal(deck.deal_card) if user.cards.size < 3 && user.score < 21

    self.message = "Hit"
    puts table
  end

  def stop
    self.message = "Game ended"
    puts table
    puts result_table
    puts winner
    puts 'Again? (Y/N)'
    call if gets.chomp.upcase == 'Y'
  end

  def result_table
    "#{user.name}, (#{user.score}), | #{user.cards.join(' | ')} |\n" +
      "#{dealer.name}, (#{dealer.score}), | #{dealer.cards.join(' | ')} |"
  end

  def winner
    if user.score < 22 && (user.score > dealer.score || dealer.score > 21)
      "#{user.name} win!"
    elsif user.score == dealer.score
      'Draw'
    else
      "#{dealer.name} win!"
    end
  end
end
