require 'terminal-table'

class Card
  attr_reader :card_name
  attr_accessor :states

  class InvalidCardDefinitionError < StandardError
  end

  def initialize(card_name, states)
    raise InvalidCardDefinitionError unless states
    @states = states
    @card_name = card_name
  end

  def visual_print
    rows = []
    states.each_key do |key|
      rows << [key, states[key]].flatten
    end
    puts Terminal::Table.new :title => "Card #{@card_name}", :headings => ['Tape Value', 'Overwrite', 'Move', 'Next Card'], :rows => rows
  end
end