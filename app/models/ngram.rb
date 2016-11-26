class Ngram
	include ::Mongoid::Document

  field :word, type: String, default: ""
  field :n_gram_2, type: String, default: ""
  field :n_gram_3, type: String, default: ""
  field :n_gram_4, type: String, default: ""
  
end