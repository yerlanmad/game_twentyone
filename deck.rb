class Deck
  attr_reader :deck

  def initialize
    @deck = new_deck.shuffle
  end

  def deal_card
    deck.shift
  end

  def scoresheet
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

  private

  def ranks
    %w[A K Q J 10 9 8 7 6 5 4 3 2]
  end

  def suits
    ["\u2665", "\u2666", "\u2663", "\u2660"]
  end

  def new_deck
    suits.flat_map { |s| ranks.map { |r| r + s } }
  end
end
