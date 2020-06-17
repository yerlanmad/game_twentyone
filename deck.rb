class Deck
  include PlayingCards

  def initialize(cnt = 1)
    @deck = (2..8).include?(cnt) ? (new_deck * cnt).shuffle : new_deck.shuffle
  end

  def shuffle_deck
    @deck.shuffle!
  end

  def deal_card
    @deck.shift
  end

  def cards_in_deck
    @deck.size
  end

  private

  def new_deck
    suits.flat_map { |s| ranks.map { |r| r + s } }
  end
end
