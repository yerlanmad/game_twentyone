require_relative 'player'

class User < Player
  attr_reader :name

  private

  def post_initialize(opts)
    @name = opts[:name] || 'User'
  end
end
