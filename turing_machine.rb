require 'curses'
# Curses.noecho
# Curses.init_screen

class TuringMachine
   include Comparable

   class CardsNotDefinedError < ArgumentError
   end

   def initialize(cards)
     raise CardsNotDefinedError unless cards

     @card_position = cards.keys.first
     @cards = cards
     @tape = Tape.new
     @steps = 0
   end

   def current_card
     @cards[@card_position]
   end

   def iterate
     state = current_card.states[@tape.current_value.to_s.to_sym]

     @steps += 1
     overwrite_value, direction, next_state = state[0], state[1], state[2]

     @tape.set overwrite_value
     direction == :left ? @tape.move_left : @tape.move_right

     @card_position = next_state

     # print_tape #if size % 100 == 0
     # puts "Percent completed: #{(@steps / 106.0)*100.0}%, Steps: #{@steps}, Size: #{size}" if size % 2 == 0
     next_state == :halt
   end

   def run
     loop do
       break if self.iterate
     end

     puts "Cards: #{@cards}"
     puts "TURING MACHINE HALTED - Steps: #{@steps}, Size: #{size}"
   end

   def size
     @tape.size
   end

   def print_tape
     # @tape.tape.each_with_index do |item, index|
     #  Curses.setpos(0, index)
     #  Curses.addstr(item.to_s)
     #  Curses.refresh
       # sleep(0.01)
     # end
     puts @tape.tape.join(' ')
     puts ""
   end

   def <=>(another_tm)
     if self.size < another_tm.size
       -1
     elsif self.size > another_tm.size
       1
     else
       0
     end
   end
 end
