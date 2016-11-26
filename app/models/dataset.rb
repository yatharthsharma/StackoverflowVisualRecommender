class Dataset
	include ::Mongoid::Document

  field :title, type: String, default: ""
  field :content, type: String, default: ""
  field :time, type: DateTime
  field :code, type: String, default: ""
  field :accepted_rate, type: String, default: ""

  field :reputation, type: String, default: ""


 
  
end