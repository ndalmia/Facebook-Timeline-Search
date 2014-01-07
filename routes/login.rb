class MyApp < Sinatra::Application
	get '/login' do
		if session[:user]
			user = User.first(:token => session[:user])
			username=""
			if user!=nil and user.Registered then
				username =user.Username
				redirect "/#{username}"
			end
		end
		
		erb:login
	end
	
	post '/login' do
		if User.first(:Email => params[:user])==nil and User.first(:Username => params[:user])==nil then
			"User don't exist"
			else
			user = nil
			if User.first(:Email => params[:user]) == nil then
				user = User.first(:Username => params[:user])
				else 
				user = User.first(:Email => params[:user])
			end
			if !user.Registered then
				"User don't exist"
				else
				if user.password_hash == BCrypt::Engine.hash_secret(params[:password], user.password_salt) then
					session[:user] = user.token 
					session[:registerstep] = nil
					session[:registeruser] = nil
					"success"
					else
					"Wrong Password."
				end
			end
		end
	end		
	
	get '/logout' do
		session[:user]=nil
		redirect '/'
	end
end
