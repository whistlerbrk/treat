module Treat
  # Algorithms to retrieve the inflections of a word. 
  module Inflectors
    # Return the stem (*not root form*) of a word.
    module Stem
      extend Group
      self.type = :annotator
      self.targets = [:word]
    end
    # Retrieve the different declensions of a noun (singular, plural).
    module Declensions
      extend Group
      self.type = :annotator
      self.targets = [:word]
    end
    # Retrieve the different conjugations of a word.
    module Conjugations
      extend Group
      self.type = :annotator
      self.targets = [:word]
    end
    # Retrieve the full text description of a cardinal number.
    module CardinalWords
      extend Group
      self.type = :annotator
      self.targets = [:number]
    end
    # Retrieve the full text description of an ordinal number.
    module OrdinalWords
      extend Group
      self.type = :annotator
      self.targets = [:number]
    end
    extend Treat::Category
  end
end
