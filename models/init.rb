DataMapper.setup(:default, "mysql://root:9251575001@127.0.0.1:3306/facebook")

	
require_relative 'tables'

DataMapper.finalize
DataMapper.auto_upgrade!