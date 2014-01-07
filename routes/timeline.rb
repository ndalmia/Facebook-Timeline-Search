class MyApp < Sinatra::Application
	get '/edit' do
		if session[:user]==nil then
			redirect '/'
		else
			user = User.first(:token => session[:user])
			username = ""
			if not(user and user.Registered) then
				redirect '/'
			end
			username = user.Username
			profilepic = "#{username}/profilepic.jpg"
			name = user.Name
			friends = user.FriendPrivacy
			pending = user.PendingPrivacy
			events = user.EventsPrivacy
			photos = user.PhotosPrivacy
			posts = user.PostsPrivacy
			erb:privacy,  :locals => {:name => name, :friends => friends, :profilepic => profilepic, :pending => pending, :events => events, :photos => photos, :posts => posts}
		end
	end
	
	post '/privacy' do
		if session[:user]==nil then
			"You need to Login first"
		else
			user = User.first(:token => session[:user])
			username = ""
			if not(user and user.Registered) then
				"You have not registered yet"
			else
			user.PhotosPrivacy = params[:photos]
			user.PostsPrivacy = params[:posts]
			user.EventsPrivacy = params[:events]
			user.PendingPrivacy = params[:pending]
			user.FriendPrivacy = params[:friends]
			user.save
			"success"
			end
		end
	end
	
	
	get '/:username' do
		if session[:user]==nil then
			redirect '/'
			else
			user = User.first(:token => session[:user])
			username = ""
			if not(user and params[:username]==user.Username and user.Registered) then
				redirect '/'
			end
			
			search =""
			if not(params[:q] == nil) then
				search = params[:q]
			end
			
			username = user.Username
			profilepic = "#{username}/profilepic.jpg"
			name = user.Name
			content = ""
			
			if search =="" then
			content = getContentNotQueryBased()
			else 
			content = getContentQueryBased(search)
			end
			
			erb:timeline, :locals => {:name => name, :profilepic => profilepic, :content => content}
		end
	end
	
end
