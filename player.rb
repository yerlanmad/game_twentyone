class Player
  attr_reader :name, :hand

  def initialize(name)
    @name = name
    hand_clear
  end

  def hand=(card)
    @hand << card
  end

  def hand_clear
    @hand = []
  end

  def cards_in_hand
    @hand.size
  end
end
