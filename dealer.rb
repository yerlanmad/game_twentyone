class Dealer < Player
  def move(game)
    deal(self, game) if game.hand_score(self) < 17
  end

  def deal(player, game)
    return unless player.cards_in_hand < 3 && game.hand_score(player) < 21

    player.hand = game.deal_card
  end
end
