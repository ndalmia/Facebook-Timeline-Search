class MyApp < Sinatra::Application
	get '/register' do
		if session[:user]
			user = User.first(:token => session[:user])
			username=""
			if user and user.Registered then
				username =user.Username
				redirect "/#{username}"
			end
		end
		if session[:registerstep]==nil then 
			erb(:register1)
			elsif session[:registerstep]=="2" then
			erb(:createpassword)
		end
	end
	
	
	post '/register1' do
		File.open('uploads/1.html', "w") do |f|
			f.write(params[:file1][:tempfile].read)
		end
		a,username = parseprofile()
		if(!a) then
			erb(:register2)
		else
			File.open('uploads/2.html', "w") do |f|
				f.write(params[:file2][:tempfile].read)
			end
			File.open('uploads/3.html', "w") do |f|
				f.write(params[:file3][:tempfile].read)
			end
			File.open('uploads/4.html', "w") do |f|
				f.write(params[:file4][:tempfile].read)
			end
			Dir.mkdir("public/#{username}")
			File.open("public/#{username}/profilepic.jpg", "wb") { |f| f.write(params[:file5][:tempfile].read) }
			File.open('uploads/6.html', "w") do |f|
				f.write(params[:file6][:tempfile].read)
			end
			File.open('uploads/7.html', "w") do |f|
				f.write(params[:file7][:tempfile].read)
			end
			File.open('uploads/8.html', "w") do |f|
				f.write(params[:file8][:tempfile].read)
			end
			File.open('uploads/9.html', "w") do |f|
				f.write(params[:file9][:tempfile].read)
			end
			
			File.open("uploads/1.zip","wb") { |f| f.write(params[:file10][:tempfile].read) }
			
			Archive::Zip.extract("uploads/1.zip", "public/#{username}")
			
			parsefriend(username)
			parsepending(username)
			parsephotos(username)
			parseevents(username)
			parsewall(username)
			user = User.first(:Username => username)
			user.FriendPrivacy = params[:file2select]
			user.PendingPrivacy = params[:file3select]
			user.EventsPrivacy = params[:file4select]
			user.PhotosPrivacy = params[:file10select]
			user.PostsPrivacy = params[:file9select]
			user.save
			session[:registerstep]="2"
			session[:registeruser]=username
			redirect '/register'
		end
	end
	
	post '/register2' do
		username = session[:registeruser]
		newuser = User.first(:Username => username)
		newuser.password_salt = BCrypt::Engine.generate_salt
		newuser.password_hash = BCrypt::Engine.hash_secret(params["password"], newuser.password_salt)
		token = SecureRandom.hex
		tokenuser=User.all(:token => token)
		while tokenuser.length!=0
			token = SecureRandom.hex
			tokenuser=User.all(:token => token)
		end
		newuser.token=token		
		newuser.Registered=true
		newuser.save
		session[:user] = newuser.token 
		session[:registerstep]=nil
		session[:registeruser]=nil
		redirect "/#{username}"
	end
	end							