class Deck
  include PlayingCards
  attr_reader :deck

  def initialize(count = 1)
    @deck = new_deck * count
    mix
  end

  def mix
    deck.shuffle!
  end

  def deal_card
    deck.shift
  end

  def cards_in_deck
    deck.size
  end

  private

  def new_deck
    suits.flat_map { |s| ranks.map { |r| r + s } }
  end
end
