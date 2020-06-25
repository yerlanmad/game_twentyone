class Player
  attr_reader :cards, :scoresheet

  def initialize(**opts)
    @scoresheet = opts[:scoresheet] || {}
    @cards = []
    post_initialize(opts)
  end

  def score
    score = cards.inject(0) { |sum, card| sum + scoresheet[card] }
    cards.select { |c| c.include?('A') }.each { score -= 10 if score > 21 }
    score
  end

  def deal(card)
    cards << card
  end

  protected

  # subclasses may override
  def post_initialize(opts); end
end
