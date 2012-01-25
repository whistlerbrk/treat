module Treat
  module Extractors
    module TopicWords
      # An adapter for the 'lda-ruby' gem, which clusters
      # documents into topics based on Latent Dirichlet
      # Allocation.
      #
      # Original paper:
      # Blei, David M., Ng, Andrew Y., and Jordan, Michael
      # I. 2003. Latent dirichlet allocation. Journal of
      # Machine Learning Research. 3 (Mar. 2003), 993-1022.
      # 
      # Project website: https://github.com/ealdent/lda-ruby
      class LDA
        # Require the lda-ruby gem.
        silence_warnings { require 'lda-ruby' }
        # Monkey patch the TextCorpus class to call it without
        # having to create any files.
        Lda::TextCorpus.class_eval do
          # Ruby, Y U NO SHUT UP!
          silence_warnings { undef :initialize }
          # Redefine initialize to take in an array of texts.
          def initialize(texts)
            super(nil)
            texts.each do |text|
              add_document(Lda::TextDocument.new(self, text))
            end
          end
        end
        def self.topic_words(collection, options = {})
          # Set the options
          options[:words_per_topic] ||= 10
          options[:topics] ||= 20
          options[:iterations] ||= 20

          # Create a corpus with the collection
          texts = collection.texts.collect do |t| 
            t.to_s.encode("UTF-8", :invalid => :replace, :undef => :replace, :replace => "?")
          end
          corpus = Lda::TextCorpus.new(texts)

          # Create an Lda object for training
          lda = Lda::Lda.new(corpus)
          lda.num_topics = options[:topics]
          lda.max_iter = options[:iterations]
          # Run the EM algorithm using random starting points
          silence_streams(STDOUT, STDERR) { lda.em('random') }
          
          # Load the vocabulary.
          if options[:vocabulary]
            lda.load_vocabulary(options[:vocabulary])
          end
          
          # Get the topic words and annotate the text.
          topic_words = lda.top_words(options[:words_per_topic])
          
          topic_words.each do |i, words|
            collection.each_word do |word|
              if words.include?(word)
                word.set :is_topic_word?, true
                word.set :topic_id, i
              else
                word.set :is_topic_word?, false
              end
            end
          end
          
          topic_words
        end
      end
    end
  end
end