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

     # state_num = {a: 1, b: 2, c: 3, d: 4}[current_card.card_name] - 1
     # (state_num - 1).times { print '   ' }
     # puts 'XXX'

     @steps += 1
     overwrite_value, direction, next_state = state[0], state[1], state[2]

     puts @steps if @steps % 100 == 0
     print_tape #if size % 100 == 0

     @tape.set overwrite_value
     direction == :left ? @tape.move_left : @tape.move_right

     @card_position = next_state

     # puts "Percent completed: #{(@steps / 106.0)*100.0}%, Steps: #{@steps}, Size: #{size}" if size % 2 == 0
     next_state == :halt
   end

   def run
     File.open("results_#{@cards.keys.count}.txt", 'w') do |file|
       @file = file
       loop do
         break if self.iterate
       end
     end

     # @cards.each_key do |c|
     #   @cards[c].visual_print
     # end
     puts "TURING MACHINE HALTED - Steps: #{@steps}, Size: #{size}"
   end

   def num_cards
     @cards.size
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
     @file.puts @tape.tape.join(' ').gsub('0', ' ').gsub('1','X')
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
