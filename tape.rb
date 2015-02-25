
class Tape
  attr_reader :tape, :position

  class NoValueSpecifiedError < StandardError
  end

  def initialize
    size = 1000
    @tape = Array.new(size, 0)
    @position = (size/2).floor
  end

  def move_left
    # puts 'left'
    @position -= 1
  end

  def move_right
    # puts 'right'
    @position += 1
  end

  def current_value
    @tape[@position]
  end

  def set(value)
    raise NoValueSpecifiedError unless value

    @tape[@position] = value
  end

  def size
   @tape.select { |t| t == 1  }.count
  end
end