class User
	include DataMapper::Resource
	
	property :Id,				Serial
	property :Email,	        String,   :length => 255, :required => true, :unique => true, :format => :email_address
	property :Username,	        String,   :length => 255, :required => true, :unique => true
	property :password_hash,  Text 
	property :password_salt,  Text
	property :token,          String,	  :unique => true
	property :Name,     String,   :required => true
	property :Registered,	Boolean,	:default => false
	property :PendingPrivacy,	String,	:default => "only me"
	property :PostsPrivacy,	String,	:default => "public"
	property :EventsPrivacy,	String,	:default => "public"
	property :PhotosPrivacy,	String,	:default => "public"
	property :FriendPrivacy,	String,	:default => "only me"
	
	has n, :friends
	has n, :posts
	has n, :photos
	has n, :events
	
end

class Friend
	include DataMapper::Resource
	
	property :Id,			Serial
	property :Type,			Enum[ :added, :pendingsent, :pendingreceived ], :default => :added
	property :Name,			String, :required => true
	
	belongs_to :user
end

class Event
	include DataMapper::Resource
	
	property :Id,				Serial
	property :Title,			Text,	:required => true
	property :Description,		Text,   :required => true
	property :StartTime,		DateTime
	property  :EndTime,			DateTime
	
	belongs_to :user
	
end

class Photo
	include DataMapper::Resource
	
	property :Id,				Serial
	property :Path,				String,	:required => true
	property :UploadedAt,		DateTime,	:required => true
	property :Description,		Text
	property :privacy,			String,	:default => "Public"
	
	belongs_to :user
	
	has n, :comments
	
end

class Post
	include DataMapper::Resource
	
	property :Id,			Serial
	property :Type,			Enum[ :text, :iv], :default => :text
	property :PostedBy,		String,	:default => "me"
	property :Description,		Text
	property :Link,			Text
	property :Photo,		Text
	property :NLikes,	Integer,	:default => 0
	property :PostedAt,		DateTime,	:required => true
	property :Privacy,			String,	:default => "Public"
	
	belongs_to :user
	
	has n, :comments
	
end



class Comment
	include DataMapper::Resource
	
	property :Id,	Serial
	property :Who,	String,	:required => true
	property :Cmnt,	Text,	:required => true
	
	belongs_to :photo,	:required => false
	belongs_to :post,	:required => false
	
end
