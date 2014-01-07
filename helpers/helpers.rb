module Helpers
	def getcontent(search)
		
	end
	
	def parseprofile()
		f = File.open("uploads/1.html")
		doc = Nokogiri::HTML(f)
		name = doc.at_css('#rhs h1').text
		username = doc.at_css('.url a').text.split('/')[-1]
		email = doc.at_css('.email').text
		if User.first(:Email => email)==nil and User.first(:Username => username)==nil then
			User.create(:Email => email, :Username => username, :Name => name)
			return true,username
			else
			return false,""
		end
		f.close
	end	
	
	def parsefriend(username)
		f = File.open("uploads/2.html")
		doc = Nokogiri::HTML(f)
		user = User.first(:Username => username)
		doc.css('#content .profile').each do |friend|
			user.friends.create(:Name => friend.text)
		end
		f.close
	end	
	
	def parsepending(username)
		f = File.open("uploads/3.html")
		doc = Nokogiri::HTML(f)
		user = User.first(:Username => username)
		doc.css('#content table').each do |table|
			if table.at_css('th').text == "Pending Sent Friend Requests" then
				table.css('td').each do |friend|
					user.friends.create(:Type => :pendingsent, :Name => friend.text)
				end
				else
				table.css('td').each do |friend|
					user.friends.create(:Type => :pendingreceived, :Name => friend.text)
				end
			end
		end
		f.close
	end
	
	def parsephotos(username)
		f = File.open("uploads/6.html")
		doc = Nokogiri::HTML(f)
		user = User.first(:Username => username)
		doc.css('.photo-container').each do |photo|
			path = photo.at_css('table a')['href'][2..-1]
			description =""
			if not(photo.at_css('.fn') == nil) and not(photo.at_css('author') and photo.at_css('.fn').text == photo.at_css('.author').text) then description = photo.at_css('.fn').text end
			uploadedat = photo.at_css('abbr')['title']
			pho = user.photos.create(:Path => path, :Description => description, :UploadedAt => uploadedat)
			photo.css('.hentry').each do |comment|
				who = comment.at_css('.fn').text
				cmnt = comment.at_css('.entry-title').text
				pho.comments.new(:Who => who, :Cmnt => cmnt)
				user.save
			end
		end
		f.close
		f = File.open("uploads/7.html")
		doc = Nokogiri::HTML(f)
		doc.css('.photo-container').each do |photo|
			path = photo.at_css('table a')['href'][2..-1]
			description =""
			if not(photo.at_css('.fn') == nil) and not(photo.at_css('author') and photo.at_css('.fn').text == photo.at_css('.author').text) then description = photo.at_css('.fn').text end
			uploadedat = photo.at_css('abbr')['title']
			pho = user.photos.create(:Path => path, :Description => description, :UploadedAt => uploadedat)
			photo.css('.hentry').each do |comment|
				who = comment.at_css('.fn').text
				cmnt = comment.at_css('.entry-title').text
				pho.comments.new(:Who => who, :Cmnt => cmnt)
				user.save
			end
		end
		f.close
		f = File.open("uploads/8.html")
		doc = Nokogiri::HTML(f)
		doc.css('.photo-container').each do |photo|
			path = photo.at_css('table a')['href'][2..-1]
			description =""
			if not(photo.at_css('.fn') == nil) and not(photo.at_css('author') and photo.at_css('.fn').text == photo.at_css('.author').text) then description = photo.at_css('.fn').text end
			uploadedat = photo.at_css('abbr')['title']
			pho = user.photos.create(:Path => path, :Description => description, :UploadedAt => uploadedat)
			photo.css('.hentry').each do |comment|
				who = comment.at_css('.fn').text
				cmnt = comment.at_css('.entry-title').text
				pho.comments.new(:Who => who, :Cmnt => cmnt)
				user.save
			end
		end
		f.close
	end
	
	def parseevents(username)
		f = File.open("uploads/4.html")
		doc = Nokogiri::HTML(f)
		user = User.first(:Username => username)
		doc.css('.event').each do |event|
			title = event.at_css('h2 a').text
			description =""
			if not(event.at_css('.description') == nil) then description = event.at_css('.description').text end
			starttime=nil
			endtime=nil
			event.css('abbr').each do |time|
				if starttime==nil then
					starttime=time['title']
					else 
					endtime=time['title']
				end
			end
			user.events.create(:Title=>title, :Description => description, :StartTime => starttime, :EndTime=> endtime)
		end
		f.close
	end
	
	def parsewall(username)
		f = File.open("uploads/9.html")
		doc = Nokogiri::HTML(f)
		user = User.first(:Username => username)
		doc.css('.feedentry').each do |post|
			if post.css('.walllink img').size==0 then
				who = post.at_css('.author  .profile').text
				if who == user.Name then who="me" end
				description = post.at_css('.entry-title').text
				dati = post.at_css('.timerow abbr')['title']
				privacy ="Public"
				if not(post.at_css('.privacy')==nil) then
					privacy = post.at_css('.privacy')['title']
				end
				post = post.css('.hfeed')
				nlike =0
				if post.size > 0 then
					if post.at_css('.like') then nlike = post.at_css('.like').text.split(' ')[0] end
				end
				curr = user.posts.create( :PostedBy => who, :Description => description, :NLikes => nlike, :PostedAt => dati, :Privacy => privacy) 
				if post.size > 0 then
					post.css('.hentry').each do |comment|
						cmntwho = comment.at_css('.fn').text
						cmnt = comment.at_css('.entry-content').text
						curr.comments.new(:Who => cmntwho, :Cmnt => cmnt)
						user.save
					end
				end
				else
				who = post.at_css('.author  .profile').text
				description = post.at_css('.entry-content').text
				dati = post.at_css('.timerow abbr')['title']
				privacy ="Public"
				if not(post.at_css('.privacy')==nil) then
					privacy = post.at_css('.privacy')['title']
				end
				link = post.at_css('.walllink a')['href']
				photo = post.at_css('.walllink img')['src']
				if who == user.Name then who="me" end
				user.posts.create(:Type => :iv, :PostedBy => who, :Description => description, :Link => link, :Photo => photo, :PostedAt => dati, :Privacy => privacy)
			end
		end
	end
	
	def eventappend(content,event)
		user = event.user
		content+="<li data-User=\"#{user.Name}\"\ data-Type=\"\Event\"\ data-Year=\"\ #{event.StartTime.year}\"\ data-Month=\"\ #{event.StartTime.strftime("%B")}\"\><div class=\"\liheader\"\><strong>#{user.Name}</strong> is going to an Event</div><div class=\"\lititle\"\>#{event.Title}</div><div class=\"\lidescription\"\>#{event.Description}</div><div class=\"\litime\"\>#{event.StartTime.strftime("%A, %B %d, %Y at %I:%M%p")} - #{event.EndTime.strftime("%A, %B %d, %Y at %I:%M%p")}</div></li>"  
		return content
	end
	
	def statusappend(content,status)
		user = status.user
		postedby = user.Name
		comments = status.comments.all(:fields => [:Who])
		commentedby = ""
		start = true
		temp=Array.new
		comments.each do |comment|
			if start then
				commentedby += comment.Who
				temp.push(comment.Who)
				start = false
				else
				if temp.include?(comment.Who)==false then
					commentedby +=", "+comment.Who
					temp.push(comment.Who)
				end
			end
		end
		if not(status.PostedBy == "me") then 
			postedby = status.PostedBy 
			if status.NLikes == 0 then
				if commentedby=="" then
					content+="<li data-User=\"#{user.Name}\"\ data-Type=\"\Status\"\ data-Posted-By=\"#{postedby} \"\ data-Year=\"\ #{status.PostedAt.year}\"\ data-Month=\"\ #{status.PostedAt.strftime("%B")}\"\><div class=\"\liheader\"\><strong>#{postedby}</strong> posted in #{user.Name}'s Timeline</div><div class=\"\lidescription\"\>#{status.Description}</div><div class=\"\litime\"\>#{status.PostedAt.strftime("%A, %B %d, %Y at %I:%M%p")}</div>" 
					else
					content+="<li data-User=\"#{user.Name}\"\ data-Type=\"\Status\"\ data-Posted-By=\"#{postedby} \"\ data-Commented-By=\"#{commentedby}\"\ data-Year=\"\ #{status.PostedAt.year}\"\ data-Month=\"\ #{status.PostedAt.strftime("%B")}\"\><div class=\"\liheader\"\><strong>#{postedby}</strong> posted in #{user.Name}'s Timeline</div><div class=\"\lidescription\"\>#{status.Description}</div><div class=\"\litime\"\>#{status.PostedAt.strftime("%A, %B %d, %Y at %I:%M%p")}</div>"
				end
				else
				if commentedby=="" then
					content+="<li data-User=\"#{user.Name}\"\ data-Type=\"\Status\"\ data-Posted-By=\"#{postedby} \"\ data-Year=\"\ #{status.PostedAt.year}\"\ data-Month=\"\ #{status.PostedAt.strftime("%B")}\"\><div class=\"\liheader\"\><strong>#{postedby}</strong> posted in #{user.Name}'s Timeline</div><div class=\"\lidescription\"\>#{status.Description}</div><div class=\"\litime\"\>#{status.PostedAt.strftime("%A, %B %d, %Y at %I:%M%p")}</div><div class=\"\lilike\"\>#{status.NLikes} likes</div>" 
					else
					content+="<li data-User=\"#{user.Name}\"\ data-Type=\"\Status\"\ data-Posted-By=\"#{postedby} \"\ data-Commented-By=\"#{commentedby}\"\ data-Year=\"\ #{status.PostedAt.year}\"\ data-Month=\"\ #{status.PostedAt.strftime("%B")}\"\><div class=\"\liheader\"\><strong>#{postedby}</strong> posted in #{user.Name}'s Timeline</div><div class=\"\lidescription\"\>#{status.Description}</div><div class=\"\litime\"\>#{status.PostedAt.strftime("%A, %B %d, %Y at %I:%M%p")}</div><div class=\"\lilike\"\>#{status.NLikes} likes</div>" 
				end
			end
			else 
			if status.NLikes == 0 then
				if commentedby=="" then
					content+="<li data-User=\"#{user.Name}\"\ data-Type=\"\Status\"\ data-Posted-By=\"#{postedby} \"\ data-Year=\"\ #{status.PostedAt.year}\"\ data-Month=\"\ #{status.PostedAt.strftime("%B")}\"\><div class=\"\liheader\"\><strong>#{user.Name}</strong> updated his Status</div><div class=\"\lidescription\"\>#{status.Description}</div><div class=\"\litime\"\>#{status.PostedAt.strftime("%A, %B %d, %Y at %I:%M%p")}</div>"  
					else 
					content+="<li data-User=\"#{user.Name}\"\ data-Type=\"\Status\"\ data-Posted-By=\"#{postedby} \"\ data-Commented-By=\"#{commentedby}\"\ data-Year=\"\ #{status.PostedAt.year}\"\ data-Month=\"\ #{status.PostedAt.strftime("%B")}\"\><div class=\"\liheader\"\><strong>#{user.Name}</strong> updated his Status</div><div class=\"\lidescription\"\>#{status.Description}</div><div class=\"\litime\"\>#{status.PostedAt.strftime("%A, %B %d, %Y at %I:%M%p")}</div>"
				end
				else
				if commentedby=="" then
					content+="<li data-User=\"#{user.Name}\"\ data-Type=\"\Status\"\ data-Posted-By=\"#{postedby} \"\ data-Year=\"\ #{status.PostedAt.year}\"\ data-Month=\"\ #{status.PostedAt.strftime("%B")}\"\><div class=\"\liheader\"\><strong>#{user.Name}</strong> updated his Status</div><div class=\"\lidescription\"\>#{status.Description}</div><div class=\"\litime\"\>#{status.PostedAt.strftime("%A, %B %d, %Y at %I:%M%p")}</div><div class=\"\lilike\"\>#{status.NLikes} likes</div>"  
					else 
					content+="<li data-User=\"#{user.Name}\"\ data-Type=\"\Status\"\ data-Posted-By=\"#{postedby} \"\ data-Commented-By=\"#{commentedby}\"\ data-Year=\"\ #{status.PostedAt.year}\"\ data-Month=\"\ #{status.PostedAt.strftime("%B")}\"\><div class=\"\liheader\"\><strong>#{user.Name}</strong> updated his Status</div><div class=\"\lidescription\"\>#{status.Description}</div><div class=\"\litime\"\>#{status.PostedAt.strftime("%A, %B %d, %Y at %I:%M%p")}</div><div class=\"\lilike\"\>#{status.NLikes} likes</div>"  
				end
			end
		end
		comments = status.comments
		comments.each do |comment|
			content+="<div class=\"\licomment\"\><strong>#{comment.Who}</strong> : #{comment.Cmnt}</div>"
		end
		content+="</li>"
		return content
	end
	
	def otherpostappend(content,otherpost)
		user = otherpost.user
		postedby = user.Name
		postedat = "his"
		if not(otherpost.PostedBy == "me") then 
			postedby = otherpost.PostedBy
			postedat = user.Name+"'s"
		end 
		content+="<li data-User=\"#{user.Name}\"\ data-Type=\"\Other Posts\"\ data-Posted-By=\"#{postedby} \"\ data-Year=\"\ #{otherpost.PostedAt.year}\"\ data-Month=\"\ #{otherpost.PostedAt.strftime("%B")}\"\><div class=\"\liheader\"\><strong>#{postedby}</strong> posted in #{postedat} Timeline</div><div class=\"\liimglink\"\><a href=\"\ #{otherpost.Link}\"\><img src=\"\ #{otherpost.Photo}\"\ /></a></div><div class=\"\lidescription\"\>#{otherpost.Description}</div><div class=\"\litime\"\>#{otherpost.PostedAt.strftime("%A, %B %d, %Y at %I:%M%p")}</div></li>"  
		return content
	end
	
	def photoappend(content,photo)
		user = photo.user
		path = user.Username+"/"+photo.Path
		comments = photo.comments.all(:fields => [:Who])
		commentedby = ""
		start = true
		temp=Array.new
		comments.each do |comment|
			if start then
				commentedby += comment.Who
				temp.push(comment.Who)
				start = false
				else
				if temp.include?(comment.Who)==false then
					commentedby +=", "+comment.Who
					temp.push(comment.Who)
				end
			end
		end
		if commentedby=="" then
			content+="<li data-User=\"#{user.Name}\"\ data-Type=\"\Photo\"\ data-Year=\"\ #{photo.UploadedAt.year}\"\ data-Month=\"\ #{photo.UploadedAt.strftime("%B")}\"\><div class=\"\liheader\"\><strong>#{user.Name}</strong> uploaded a Photo</div><div class=\"\liphotoimg\"\><img src=\"\ #{path} \"\ /></div><div class=\"\lidescription\"\>#{photo.Description}</div><div class=\"\litime\"\>#{photo.UploadedAt.strftime("%A, %B %d, %Y at %I:%M%p")}</div>"  
			else
			content+="<li data-User=\"#{user.Name}\"\ data-Type=\"\Photo\"\ data-Commented-By=\"#{commentedby}\"\ data-Year=\"\ #{photo.UploadedAt.year}\"\ data-Month=\"\ #{photo.UploadedAt.strftime("%B")}\"\><div class=\"\liheader\"\><strong>#{user.Name}</strong> uploaded a Photo</div><div class=\"\liphotoimg\"\><img src=\"\ #{path} \"\ /></div><div class=\"\lidescription\"\>#{photo.Description}</div><div class=\"\litime\"\>#{photo.UploadedAt.strftime("%A, %B %d, %Y at %I:%M%p")}</div>"  
		end
		comments = photo.comments.all
		comments.each do |comment|
			content+="<div class=\"\licomment\"\><strong>#{comment.Who}</strong> : #{comment.Cmnt}</div>"
		end
		content+="</li>"		
		return content		
	end
	
	def friendappend(content,friend)
	user = friend.user
	content+="<li data-User=\"#{user.Name}\"\ data-Type=\"\Friend\"\><div class=\"\liheader\"\><strong>#{user.Name}</strong> and <strong>#{friend.Name}</strong> are now Friends</div></li>"
	return content
	end
	
	def psappend(content,ps)
		user = ps.user
		content+="<li data-User=\"#{user.Name}\"\ data-Type=\"\Sent Request\"\><div class=\"\liheader\"\><strong>#{user.Name}</strong> sent a friend request to <strong>#{ps.Name}</strong></div></li>"
		return content
	end
	
	def prappend(content,pr)
		user = pr.user
		content+="<li data-User=\"#{user.Name}\"\ data-Type=\"\Received Request\"\><div class=\"\liheader\"\><strong>#{user.Name}</strong> received a friend request from <strong>#{pr.Name}</strong></div></li>"
		return content
	end
	
	def getContentNotQueryBased()
		curruser = User.first(:token => session[:user])
		curruserid = curruser.Id
		
		
		users = User.all
		friends = Friend.all(:Type => :added, :user => {:Id => curruser.Id})
		users.each do |user|
			friends += Friend.all(:Type => :added, :user => {:Id => user.Id})
		end
		friends2 = Friend.all(:Type => :added, :user => {:Id => curruser.Id})
		#friends = repository(:default).adapter.query("select distinct users.name as n2,friends.name as n1 from friends,users where friends.type=1 and friends.user_id=users.id")
		pendingsent = Friend.all(:Type => :pendingsent, :user => {:Id => curruserid})
		pendingreceived = Friend.all(:Type => :pendingreceived, :user => {:Id => curruserid})
		events = Event.all(:user => {:Id => curruserid})
		statuses = Post.all(:Type => :text,:user => {:Id => curruserid})
		otherposts = Post.all(:Type => :iv,:user => {:Id => curruserid})
		photos = Photo.all(:user => {:Id => curruserid})
		users.each do |user|
			isfriend=false
			friends.each do |friend|
				if (user.Name == friend.Name and curruser.Name == friend.user.Name) or (user.Name == friend.user.Name and curruser.Name == friend.Name) then
					isfriend=true
				end
			end
			if not(user.Id == curruserid) then
				if user.PendingPrivacy == "public" or (user.PendingPrivacy == "friends" and isfriend) then
					pendingsent = pendingsent | Friend.all(:Type => :pendingsent, :user => {:Id => user.Id})
					pendingreceived = pendingreceived + Friend.all(:Type => :pendingreceived, :user => {:Id => user.Id})
				end
				if user.EventsPrivacy == "public" or (user.EventsPrivacy == "friends" and isfriend) then
					events = events + Event.all(:user => {:Id => user.Id})
				end
				if user.PostsPrivacy == "public" or (user.PostsPrivacy == "friends" and isfriend) then
					statuses = statuses + Post.all(:Type => :text, :Privacy.like => '%Public%',:user => {:Id => user.Id})
					if isfriend then
						statuses = statuses + Post.all(:Type => :text, :Privacy.like => '%Friends%',:user => {:Id => user.Id})
					end
					otherposts = otherposts + Post.all(:Type => :iv, :Privacy.like => '%Public%',:user => {:Id => user.Id})
					if isfriend then
						otherposts = otherposts + Post.all(:Type => :iv, :Privacy.like => '%Friends%',:user => {:Id => user.Id})
					end
				end
				if user.PhotosPrivacy == "public" or (user.PhotosPrivacy == "friends" and isfriend) then
					photos = photos + Photo.all(:user => {:Id => user.Id})
				end
				if user.FriendPrivacy == "public" or (user.FriendPrivacy == "friends" and isfriend) then
					friends2 += Friend.all(:Type => :added, :user => {:Id => user.Id})
				end
			end
		end
		
		events = events.all(:order => [:StartTime.desc])
		statuses = statuses.all(:order => [:PostedAt.desc])
		otherposts = otherposts.all(:order => [:PostedAt.desc])
		photos = photos.all(:order => [:UploadedAt.desc])
		
		neventcount = events.count
		nstatuscount = statuses.count
		notherpostcount = otherposts.count
		nphotocount = photos.count
		
		eventindex=0
		statusindex=0
		otherpostindex=0
		photoindex=0
		
		content=""
		while eventindex<neventcount or statusindex<nstatuscount or otherpostindex<notherpostcount or photoindex<nphotocount do
			arr = Array.new
			if eventindex<neventcount then arr.push(events[eventindex].StartTime) end
			if statusindex<nstatuscount then arr.push(statuses[statusindex].PostedAt) end
			if otherpostindex<notherpostcount then arr.push(otherposts[otherpostindex].PostedAt) end
			if photoindex<nphotocount then arr.push(photos[photoindex].UploadedAt) end
			
			max = arr.max
			if eventindex<neventcount and max==events[eventindex].StartTime then
				content = eventappend(content,events[eventindex])
				eventindex+=1
				elsif statusindex<nstatuscount and max==statuses[statusindex].PostedAt then 
				content = statusappend(content,statuses[statusindex])
				statusindex+=1
				elsif otherpostindex<notherpostcount and max==otherposts[otherpostindex].PostedAt then
				content = otherpostappend(content,otherposts[otherpostindex])
				otherpostindex+=1
				else
				content = photoappend(content,photos[photoindex])
				photoindex+=1
			end
		end
		
		friends2.each do |friend|
			content = friendappend(content,friend)
		end
		pendingsent.each do |ps|
			content = psappend(content,ps)
		end
		pendingreceived.each do |pr|
			content = prappend(content,pr)
		end
		
		return content
	end
	
	def getContentQueryBased(query)
		curruser = User.first(:token => session[:user])
		curruserid = curruser.Id
		
		
		users = User.all
		friends = Friend.all(:Type => :added, :user => {:Id => curruser.Id})
		users.each do |user|
			friends += Friend.all(:Type => :added, :user => {:Id => user.Id})
		end
		friends2 = Friend.all(:Type => :added, :user => {:Id => curruser.Id})
		#friends = repository(:default).adapter.query("select distinct users.name as n2,friends.name as n1 from friends,users where friends.type=1 and friends.user_id=users.id")
		pendingsent = Friend.all(:Type => :pendingsent, :user => {:Id => curruserid})
		pendingreceived = Friend.all(:Type => :pendingreceived, :user => {:Id => curruserid})
		events = Event.all(:user => {:Id => curruserid})
		statuses = Post.all(:Type => :text,:user => {:Id => curruserid})
		otherposts = Post.all(:Type => :iv,:user => {:Id => curruserid})
		photos = Photo.all(:user => {:Id => curruserid})
		users.each do |user|
			isfriend=false
			friends.each do |friend|
				if (user.Name == friend.Name and curruser.Name == friend.user.Name) or (user.Name == friend.user.Name and curruser.Name == friend.Name) then
					isfriend=true
				end
			end
			if not(user.Id == curruserid) then
				if user.PendingPrivacy == "public" or (user.PendingPrivacy == "friends" and isfriend) then
					pendingsent = pendingsent | Friend.all(:Type => :pendingsent, :user => {:Id => user.Id})
					pendingreceived = pendingreceived + Friend.all(:Type => :pendingreceived, :user => {:Id => user.Id})
				end
				if user.EventsPrivacy == "public" or (user.EventsPrivacy == "friends" and isfriend) then
					events = events + Event.all(:user => {:Id => user.Id})
				end
				if user.PostsPrivacy == "public" or (user.PostsPrivacy == "friends" and isfriend) then
					statuses = statuses + Post.all(:Type => :text, :Privacy.like => '%Public%',:user => {:Id => user.Id})
					if isfriend then
						statuses = statuses + Post.all(:Type => :text, :Privacy.like => '%Friends%',:user => {:Id => user.Id})
					end
					otherposts = otherposts + Post.all(:Type => :iv, :Privacy.like => '%Public%',:user => {:Id => user.Id})
					if isfriend then
						otherposts = otherposts + Post.all(:Type => :iv, :Privacy.like => '%Friends%',:user => {:Id => user.Id})
					end
				end
				if user.PhotosPrivacy == "public" or (user.PhotosPrivacy == "friends" and isfriend) then
					photos = photos + Photo.all(:user => {:Id => user.Id})
				end
				if user.FriendPrivacy == "public" or (user.FriendPrivacy == "friends" and isfriend) then
					friends2 += Friend.all(:Type => :added, :user => {:Id => user.Id})
				end
			end
		end
		
		queryfriends=nil
		queryevents=nil
		querystatuses=nil
		queryotherposts=nil
		queryphotos=nil
		querypendingsent=nil
		querypendingreceived=nil
		keywordsarray = query.split(/\s+(?=(?:[^"]*"[^"]*")*[^"]*$)/).reject {|s| s.empty?} 
		allevents=false
		allphotos=false
		allstatuses=false
		allotherposts=false
		allpendingsent=false
		allpendingreceived=false
		allfriends=false
		keywordsarray.each do |key|
			key=key.upcase
			key=key.split(' ').reject { |s| s.empty?}.join(' ')
			if key[0]=="\"" then
				key = key[1..-2].split(' ').reject { |s| s.empty?}.join(' ')
			end
			if key == "FRIEND" or key == "FRIENDS" then allfriends=true end
			if key == "PENDING" or key == "REQUEST" or key == "REQUESTS" or key == "PENDING REQUEST" or key == "PENDING REQUESTS" then 
				allpendingsent=true
				allpendingreceived=true
			end
			if key == "SENT" or key=="PENDING SENT REQUEST" or key == "PENDING SENT REQUESTS"  then allpendingsent=true end
			if key == "RECEIVED" or key=="PENDING RECEIVED REQUEST" or key == "PENDING RECEIVED REQUESTS" then allpendingreceived=true end
			if key == "EVENT" or key == "EVENTS" then allevents=true end
			if key == "STATUS" or key == "STATUSES" then allstatuses=true end
			if key == "PHOTO" or key == "PHOTOS" then allphotos=true end
			if key == "POSTS" or key == "POST" then 
				allotherposts=true 
				allstatuses=true
			end
		end
		
		alllessthanfour=true
		
		keywordsarray.each do |key|
			key=key.split(' ').reject { |s| s.empty?}.join(' ')
			if key[0]=="\"" then
				key = key[1..-2].split(' ').reject { |s| s.empty?}.join(' ')
			end
			if key.length>=4 then alllessthanfour = false end
		end
		
		if alllessthanfour then
			allevents=true
			allphotos=true
			allstatuses=true
			allotherposts=true
			allpendingsent=true
			allpendingreceived=true
			allfriends=true
		end
		
		if allfriends then queryfriends=friends2 end
		if allpendingsent then querypendingsent=pendingsent end
		if allpendingreceived then querypendingreceived=pendingreceived end
		if allevents then queryevents=events end
		if allphotos then queryphotos=photos end
		if allstatuses then querystatuses=statuses end
		if allotherposts then queryotherposts=otherposts end
		eventstart=true
		photostart=true
		statusstart=true
		otherpoststart=true
		pendingsentstart=true
		pendingreceivedstart=true
		
		keywordsarray.each do |key|
			key=key.split(' ').reject { |s| s.empty?}.join(' ')
			if key[0]=="\"" then
				key = key[1..-2].split(' ').reject { |s| s.empty?}.join(' ')
			end
			if key.length<4 then next end
			if not(allevents) then 
				if eventstart then
					eventstart=false
					queryevents=events.all(:Title.like => "%#{key}%") + events.all(:Description.like => "%#{key}%")
					else
					queryevents+=events.all(:Title.like => "%#{key}%") + events.all(:Description.like => "%#{key}%")
				end
			end
			if not(allstatuses) then 
				if statusstart then
					statusstart=false
					querystatuses=statuses.all(:Description.like => "%#{key}%")
					querystatuses+=statuses.all(:comments => {:Cmnt.like => "%#{key}%"}) 
					querystatuses+=statuses.all(:comments => {:Who.like => "%#{key}%"})
					querystatuses+=statuses.all(:PostedBy.like => "%#{key}%")
					else	
					querystatuses+=statuses.all(:Description.like => "%#{key}%")
					querystatuses+=statuses.all(:comments => {:Cmnt.like => "%#{key}%"}) 
					querystatuses+=statuses.all(:comments => {:Who.like => "%#{key}%"})
					querystatuses+=statuses.all(:PostedBy.like => "%#{key}%")
				end
			end
			if not(allotherposts) then 
				if otherpoststart then
					otherpoststart=false
					queryotherposts=otherposts.all(:Description.like => "%#{key}%") + otherposts.all(:PostedBy.like => "%#{key}%")
					else	
					queryotherposts+=otherposts.all(:Description.like => "%#{key}%") + otherposts.all(:PostedBy.like => "%#{key}%")
				end
			end
			if not(allphotos) then 
				if photostart then 
					queryphotos=photos.all(:Description.like => "%#{key}%") 
					queryphotos+=photos.all(:comments => {:Cmnt.like => "%#{key}%"})  
					queryphotos+=photos.all(:comments => {:Who.like => "%#{key}%"})
					photostart=false
					else
					queryphotos+=photos.all(:Description.like => "%#{key}%") 
					queryphotos+=photos.all(:comments => {:Cmnt.like => "%#{key}%"})  
					queryphotos+=photos.all(:comments => {:Who.like => "%#{key}%"})
				end
			end
			if not(allpendingsent) then 
				if pendingsentstart then
					pendingsentstart=false
					querypendingsent=pendingsent.all(:Name.like => "%#{key}%")
					else
					querypendingsent+=pendingsent.all(:Name.like => "%#{key}%")
				end
			end
			if not(allpendingreceived) then 
				if pendingreceivedstart then
					pendingreceivedstart=false
					querypendingreceived=pendingreceived.all(:Name.like => "%#{key}%")
					else
					querypendingreceived+=pendingreceived.all(:Name.like => "%#{key}%")
				end
			end
		end
		queryevents = queryevents.all(:order => [:StartTime.desc])
		querystatuses = querystatuses.all(:order => [:PostedAt.desc])
		queryotherposts = queryotherposts.all(:order => [:PostedAt.desc])
		queryphotos = queryphotos.all(:order => [:UploadedAt.desc])
		
		neventcount = queryevents.count
		nstatuscount = querystatuses.count
		notherpostcount = queryotherposts.count
		nphotocount = queryphotos.count
		
		eventindex=0
		statusindex=0
		otherpostindex=0
		photoindex=0
		
		content=""
		while eventindex<neventcount or statusindex<nstatuscount or otherpostindex<notherpostcount or photoindex<nphotocount do
			arr = Array.new
			if eventindex<neventcount then arr.push(queryevents[eventindex].StartTime) end
			if statusindex<nstatuscount then arr.push(querystatuses[statusindex].PostedAt) end
			if otherpostindex<notherpostcount then arr.push(queryotherposts[otherpostindex].PostedAt) end
			if photoindex<nphotocount then arr.push(queryphotos[photoindex].UploadedAt) end
			
			max = arr.max
			if eventindex<neventcount and max==queryevents[eventindex].StartTime then
				content = eventappend(content,queryevents[eventindex])
				eventindex+=1
				elsif statusindex<nstatuscount and max==querystatuses[statusindex].PostedAt then 
				content = statusappend(content,querystatuses[statusindex])
				statusindex+=1
				elsif otherpostindex<notherpostcount and max==queryotherposts[otherpostindex].PostedAt then
				content = otherpostappend(content,queryotherposts[otherpostindex])
				otherpostindex+=1
				else
				content = photoappend(content,queryphotos[photoindex])
				photoindex+=1
			end
		end
		
		if allfriends then
			queryfriends.each do |friend|
				content = friendappend(content,friend)
			end
			else
			keywordsarray.each do |key|
				key=key.split(' ').reject { |s| s.empty?}.join(' ')
				if key[0]=="\"" then
					key = key[1..-2].split(' ').reject { |s| s.empty?}.join(' ')
				end
				friends2.each do |friend|
					if friend.Name =~ /#{key}/i then
						content = friendappend(content,friend)
					end
				end
			end
		end		
		querypendingsent.each do |ps|
			content = psappend(content,ps)
		end
		
		querypendingreceived.each do |pr|
			content = prappend(content,pr)
		end
		
		return content
	end
	
end	