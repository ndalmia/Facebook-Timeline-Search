class MyApp < Sinatra::Application
	get '/' do
		if session[:user]
			user = User.first(:token => session[:user])
			username=""
			if user and user.Registered then
				username =user.Username
				redirect "/#{username}"
			end
		end
		
		erb:home
	end


end