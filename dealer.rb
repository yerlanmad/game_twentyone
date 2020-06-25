require_relative 'player'

class Dealer < Player
  attr_reader :name

  private

  def post_initialize(_opts)
    @name = 'Dealer'
  end
end
