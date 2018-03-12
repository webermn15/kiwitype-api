class UserController < ApplicationController



	post '/login' do 
		success = nil

		@pw = params["password"]
		@user = User.find_by(username: params["username"])

		if @user && @user.authenticate(@pw)
			success = true
			session[:username] = @user.username
			session[:logged_in] = true
			session[:user_id] = @user.id
			session[:session_token] = @user.session_token
			session[:message] = "Logged in as #{@user.username}"
		else
			success = false
			session[:message] = "Incorrect username or password"
		end

		user_info = nil

		if success
			all_wpm = @user.lifetime_wpm().pluck(:wpm)
			if all_wpm.length > 0
				wpm_avg = (all_wpm.sum / all_wpm.length).round(2)
			else
				wpm_avg = 0
			end
			user_info = {
				id: @user.id,
				username: @user.username,
				lifetimeWpm: wpm_avg,
				session_token: @user.session_token
			}
		end

		resp = {
			user: user_info,
			message: session[:message],
			success: success
		}.to_json
	end



	post '/register' do
		@user = User.new
		@user.username = params["username"]
		@user.password = params["password"]
		@user.save
		session[:logged_in] = true
		session[:username] = @user.username
		session[:user_id] = @user.id
		session[:session_token] = @user.session_token
		session[:message] = "You are now logged in as #{session[:username]}."

		user_info = {
			id: @user.id,
			username: @user.username,
			lifetimeWpm: 0,
			session_token: @user.session_token
		}

		success = true

		resp = {
			user: user_info,
			message: session[:message],
			success: success
		}.to_json
	end



	get '/logout' do 
		success = true
		session[:logged_in] = false
		session[:username] = nil
		session[:user_id] = nil
		session[:message] = "You are now logged out."
		session[:session_token] = nil

		resp = {
			message: session[:message],
			success: success
		}.to_json
	end



	get '/token/:token' do 
		success = nil
		user_info = nil

		@user = User.where("session_token = ?", params["token"])

		if (@user) 
			success = true
			session[:username] = @user[0].username
			session[:logged_in] = true
			session[:user_id] = @user[0].id
			session[:session_token] = @user[0].session_token
		else
			success = false
		end

		if success
			all_wpm = @user[0].lifetime_wpm().pluck(:wpm)			
			if all_wpm.length > 0
				wpm_avg = (all_wpm.sum / all_wpm.length).round(2)
			else
				wpm_avg = 0
			end
			user_info = {
				id: session[:user_id],
				username: session[:username],
				lifetimeWpm: wpm_avg,
				session_token: session[:session_token]
			}
			session[:message] = 'Session resumed'
		end

		resp = {
			user: user_info,
			message: session[:message],
			success: success
		}.to_json
	end



end