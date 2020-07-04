# frozen_string_literal: true

require_relative 'player'

class Dealer < Player
  attr_reader :name

  def initialize
    @name = 'Dealer'
    super
  end
end
