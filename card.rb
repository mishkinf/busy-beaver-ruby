class Card
   attr_accessor :states

   class InvalidCardDefinitionError < StandardError
   end

   def initialize(states)
     raise InvalidCardDefinitionError unless states
     @states = states
   end
end