load 'tape.rb'
load 'card.rb'
load 'turing_machine.rb'

class Numeric
  Alph = ('a'..'z').to_a
  def alph
    s, q = '', self
    (q, r = (q - 1).divmod(26)); s.prepend(Alph[r]) until q.zero?
    s
  end
end

class BusyBeaver
  def initialize(number_cards)
    @number_cards = number_cards
  end

  # this doesn't really work. need to generate all card permutations. 
  def naive_generate(num_cards)
    cards = {}
    directions = [:right, :left]
    (0..num_cards-1).each do |i|
      cards[i.to_s.to_sym] = nil
    end
    cards.each_key do |i|
      cards[i] = Card.new({
        :'0' => [
          rand(2),
          directions[rand(2)],
          cards.keys[rand(cards.length)]
        ],
        :'1' => [
          rand(2),
          directions[rand(2)],
          cards.keys[rand(cards.length)]
        ]
      })
    end
    halt_card = rand(cards.length).to_s.to_sym
    cards[halt_card].states[rand(1).to_s.to_sym][2] = :halt

    cards
  end

  def generate_turing_machines
    # 1-state, 2-symbol
    one_card = {
      a: Card.new(:a, {:'0' => [1, :right, :halt], :'1' => [nil, nil, nil]})
    }

    # 2-state, 2-symbol
    two_cards = {
      a: Card.new(:a, {:'0' => [1, :right, :b], :'1' => [1, :left, :b]}),
      b: Card.new(:b, {:'0' => [1, :left, :a], :'1' => [1, :right, :halt]})
    }

    # 3-state, 2-symbol
    three_cards = {
      a: Card.new(:a, {:'0' => [1, :right, :b], :'1' => [1, :right, :halt]}),
      b: Card.new(:b, {:'0' => [0, :right, :c], :'1' => [1, :right, :b]}),
      c: Card.new(:c, {:'0' => [1, :left, :c], :'1' => [1, :left, :a]})
    }

    # 4-state, 2-symbol
    four_cards = {
      a: Card.new(:a, {:'0' => [1, :right, :b], :'1' => [1, :left, :b]}),
      b: Card.new(:b, {:'0' => [1, :left, :a], :'1' => [0, :left, :c]}),
      c: Card.new(:c, {:'0' => [1, :right, :halt], :'1' => [1, :left, :d]}),
      d: Card.new(:d, {:'0' => [1, :right, :d], :'1' => [0, :right, :a]})
    }

    # 5-state, 2-symbol
    five_cards = {
      a: Card.new(:a, {:'0' => [1, :right, :b], :'1' => [1, :left, :c]}),
      b: Card.new(:b, {:'0' => [1, :right, :c], :'1' => [1, :right, :b]}),
      c: Card.new(:c, {:'0' => [1, :right, :d], :'1' => [0, :left, :e]}),
      d: Card.new(:d, {:'0' => [1, :left, :a], :'1' => [1, :left, :d]}),
      e: Card.new(:e, {:'0' => [1, :right, :halt], :'1' => [0, :left, :a]})
    }

    @turing_machines = [
      TuringMachine.new(one_card),
      TuringMachine.new(two_cards),
      TuringMachine.new(three_cards),
      TuringMachine.new(four_cards)
    ]
    # @turing_machines = [TuringMachine.new(naive_generate(3))]
  end

  def run
    @turing_machines.each do |tm|
      tm.run
      tm.print_tape
    end

    @turing_machines.sort!
  end

  def self.card_permutations(n)
    (4*(n+1)) ** (2*n)
  end
end

bb = BusyBeaver.new(1)
bb.generate_turing_machines
bb.run
