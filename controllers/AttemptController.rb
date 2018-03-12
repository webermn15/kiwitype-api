class AttemptController < ApplicationController



	post '/new' do 
		wpm = params["wpm"].to_f.round(2)

		excerpt = Excerpt.where("id = ?", params["excerpt_id"])
		title = excerpt[0].title

		@attempt = Attempt.new
		@attempt.user_id = session[:user_id] || 1
		@attempt.excerpt_id = params["excerpt_id"]
		@attempt.wpm = wpm
		@attempt.save

		resp = {
			wpm: wpm,
			title: title
		}.to_json
	end



	get '/scores/:id' do 
		@allscores = 
		Attempt.select("excerpt_id, user_id, wpm, creation_date")
			.where("excerpt_id = ?", params["id"]) 
			.order("wpm DESC").to_a

		@array = []
		@allscores.map {|i| @array.push(i.user)}
		allscores = @allscores.map(&:serializable_hash)
		array = @array.map(&:serializable_hash)

		allscores.each_with_index do |j, index|
			j.delete("id")
			j["username"] = array[index]["username"]
			j["creation_date"] = j["creation_date"].strftime("%B %-d, %Y")
		end

		@userscores = 
		Attempt.select("excerpt_id, user_id, wpm, creation_date")
			.where("excerpt_id = ? AND user_id = ?", params["id"], session[:user_id])
			.order("wpm DESC").to_a

		@arraytwo = []
		@userscores.map {|k| @arraytwo.push(k.user)}
		userscores = @userscores.map(&:serializable_hash)
		arraytwo = @arraytwo.map(&:serializable_hash)

		userscores.each_with_index do |l, ind|
			l.delete("id")
			l["username"] = arraytwo[ind]["username"]
			l["creation_date"] = l["creation_date"].strftime("%B %-d, %Y")
		end

		resp = {
			allscores: allscores,
			userscores: userscores
		}.to_json
	end


	get '/test' do 
		foo = '2018-03-12T03:25:47.667Z'
		# foo.strftime("%Y-%m-%d %H:%M:%S")
		bar = foo.slice!(0, 10)
		p bar
		resp = {
		 	suck: 'eggs'
		}.to_json
	end



end