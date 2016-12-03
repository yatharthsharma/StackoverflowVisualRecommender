class DashboardController < ApplicationController
  def index

  	filter_hash = {}
    filter_hash['$text'] = {'$search' => "public"} 
  	# @data = Stackoverflow.all.last

  # 		@coll_copy = []
		# @tags = Stackoverflow.collection.find(
		# 	{"$text" =>{ "$search" => "public static"}},
		# 	{"score" => {"$meta" =>'textScore'}}).limit(2)

		#todo sort the above row
		# # .sort({"score" => {"$meta" =>  'textScore'}}).
		# @code_sim = Stackoverflow.collection.aggregate(
		# 	[{"$match" =>  {"$text" => {"$search"  =>  params['data']}}},
		# 	{"$project" => {"tags_array" => 1,"title" => 1,"type" => 1,"vote" => 1,"code" => 1,"score" => {"$meta" => "textScore"},"_id" =>  0}},
		# 	{"$match" => {"score"  => {"$gt" =>  1 }}},
		# 	{"$unwind" => "$tags_array"},
		# 	{"$group" => 
		# 	{"_id" => {"question" => "$title", "key" => "$code", "tags" =>  "$tags_array"},"value" => {"$sum" => "$vote"}}},
		# 	{"$project" => {"question"  => "$_id.question","key"  => "$_id.key","tags"  => "$_id.tags","value" => "$value"}},
		# 	{"$sort" => {"value" => -1}}
		# 	],{:allow_disk_use => true}) 


 	# 	respond_to do |format|
	 #      format.json { render json: @code_sim.first}
	 #    end
		# all_tags = []
		# @tags.each do |data|
		#  data['tag'].split(" ").each do |new_tag|
		#  	@coll_copy << data.merge({"name_tag" => new_tag})
		#  	print "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@22", @coll_copy,"\n"
		#  end
		
		# end

		# print @coll_copy.count
  end


	def treemap
		@code_sim = Stackoverflow.collection.aggregate(
			[{"$match" =>  {"$text" => {"$search"  =>  params['data']}}},
			{"$project" => {"tags_array" => 1,"title" => 1,"type" => 1,"value" => 1,"reputation"=>1, "vote"=>1,"code" => 1,"score" => {"$meta" => "textScore"},"_id" =>  0}},
			{"$match" => {"score"  => {"$gt" =>  1 }}},
			{"$sort" => {"score" => -1}},
			{"$limit" => 50},
			{"$unwind" => "$tags_array"},
			{"$group" => 
			{"_id" => {"question" => "$title", "key" => "$code", "tags" =>  "$tags_array", "value"=>"$value"},"vote"=> { "$first" => "$vote"},"reputation"=> { "$first" => "$reputation"}}},
			{"$project" => {"question"  => "$_id.question","key"  => "$_id.key","tag"  => "$_id.tags","value" => "$_id.value", "vote"=>"$vote", "reputation" => "$reputation"}},
			
			],{:allow_disk_use => true}) 


		# @code_sim.each do |data|
		# 	print data, "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@",'\n'
		# end
 		respond_to do |format|
	      format.json { render json: @code_sim}
	    end

	end

  def fetch_n_gram
	filter_hash = {}

		tree = Hash.new
	    data_arr = []

	  value_limit = Integer(params['limit_val'])
	    print '#################333',value_limit,value_limit.class
    @filtered_data = Finalngram.collection.aggregate(
	    	[{"$match" =>{"word" => params['word1']}},

	    	{"$group" => {"_id" => {"word" =>  "$word", "n1" =>  "$n1","n2" =>  "$n2","n3" =>  "$n3"}, 
			"count" => {"$sum" => 1}, "parent" => {"$push" => "$$ROOT"}}},
			{"$sort" => {"count" => -1}},
			{"$project" => {"_id" => 0,"word" =>  "$_id.word","n1" => "$_id.n1","n2" => "$_id.n2","name" => "$_id.n3","size" => "$count"}},
			{"$limit" => 50},

			{"$group" =>{"_id" =>{"word" => "$word", "n1" => "$n1","n2" => "$n2"}, 
			"count" => {"$sum" =>1}, "parent" =>{"$push" => "$$ROOT"}}},
			{"$sort"  =>{"count" => -1}},
			{"$project" =>{"_id" =>0,"word" => "$_id.word","n1" => "$_id.n1","name" => "$_id.n2","size" => "$count","children" => "$parent"}},
			{"$limit" => 50},

			{"$group" =>{"_id" =>{"word" => "$word", "n1" => "$n1"}, 
			"count" => {"$sum" =>1}, "parent" =>{"$push" => "$$ROOT"}}},
			{"$sort"  =>{"count" => -1}},
			{"$project" =>{"_id" =>0,"word" => "$_id.word","name" => "$_id.n1","size" => "$count","children" => "$parent"}},
			{"$limit" => 50},

			{"$group" =>{"_id" =>{"word" => "$word"}, 
			"count" => {"$sum" =>1}, "parent" =>{"$push" => "$$ROOT"}}},
			{"$sort"  =>{"count" => -1}},
			{"$project" =>{"_id" =>0,"name" => "$_id.word","size" => "$count","children" => "$parent"}},

			{"$limit" => 50}],

			{ :allow_disk_use => true}
			)



	  	respond_to do |format|
	      format.json { render json: @filtered_data.first}
	    end
 
	end

end


