class Finalngram
	include ::Mongoid::Document

  field :word, type: String, default: ""
  field :n1, type: String, default: ""
  field :n2, type: String, default: ""
  field :n3, type: String, default: ""
  field :n4, type: String, default: ""
  
end