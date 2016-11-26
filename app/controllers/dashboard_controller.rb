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
		# .sort({"score" => {"$meta" =>  'textScore'}}).
		

		# all_tags = []
		# @tags.each do |data|
		#  data['tag'].split(" ").each do |new_tag|
		#  	@coll_copy << data.merge({"name_tag" => new_tag})
		#  	print "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@22", @coll_copy,"\n"
		#  end
		
		# end

		# print @coll_copy.count
  end


  def fetch_n_gram
	filter_hash = {}

		tree = Hash.new
	    data_arr = []

	    @filtered_data = Finalngram.collection.aggregate(
	    	[{"$match" =>{"word" => params['word1']}},

			{"$group" =>{"_id" =>{"word" => "$word", "n1" => "$n1","n2" => "$n2"}, 
			"count" => {"$sum" =>1}, "parent" =>{"$push" => "$$ROOT"}}},
			{"$sort"  =>{"count" => -1}},
			{"$project" =>{"_id" =>0,"word" => "$_id.word","n1" => "$_id.n1","name" => "$_id.n2","size" => "$count"}},
			{"$limit" => 25},

			{"$group" =>{"_id" =>{"word" => "$word", "n1" => "$n1"}, 
			"count" => {"$sum" =>1}, "parent" =>{"$push" => "$$ROOT"}}},
			{"$sort"  =>{"count" => -1}},
			{"$project" =>{"_id" =>0,"word" => "$_id.word","name" => "$_id.n1","count" => "$count","children" => "$parent"}},
			{"$limit" => 25},

			{"$group" =>{"_id" =>{"word" => "$word"}, 
			"count" => {"$sum" =>1}, "parent" =>{"$push" => "$$ROOT"}}},
			{"$sort"  =>{"count" => -1}},
			{"$project" =>{"_id" =>0,"name" => "$_id.word","count" => "$count","children" => "$parent"}},

			{"$limit" => 25}],

			{ :allow_disk_use => true}
			)


	    # print   @filtered_data.to_json
	    # print "$$$$$$$$$$$$$$$$$$$$$$$", params['word1']
	  	# @filtered_data = Finalngram.collection.aggregate([
	  	# 	{"$match" => {"word" => "int"}},
	  	# 	{"$group" => {"_id" =>{"n1" =>  "$n1"},"count" => {"$sum" => 1}}},
	  	# 	{"$sort" => { "count"  => -1}},
	  	# 	{"$limit": 200},
	  	# 	{"$project":{"_id":0,'name':  "$_id.n1",count: "$count"}}],
	  	# 	{ allowDiskUse: true})

	  	# print "@@@@@@@@@@@@@@@@@", @filtered_data.count

	  		# tree['name'] = @filtered_data
	  	# 	tree['children'] = Array.new
	  	# 	@filtered_data.each do |data|
	  	# 		# print data['name']
	  	# 		data_arr << data['name']
				# tree['children'] << {"name" => data['name'] , "size" =>data['count'], "children" => Array.new}
	  	# 	end

	


	  	respond_to do |format|
	      format.json { render json: @filtered_data.first}
	    end
 
	end
end


