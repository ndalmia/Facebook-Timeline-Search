# encoding: utf-8
require 'sinatra'
require 'sinatra/reloader'
require 'data_mapper'
require 'mysql'
require 'rack'
require 'sinatra/assetpack'
require 'nokogiri'
require 'archive/zip'
require 'zip/zip'
require 'find'
require 'fileutils'
require 'bcrypt'
require 'securerandom'
require 'rack'



class MyApp < Sinatra::Application
	use Rack::Session::Cookie, :secret => 'gvgvghvghvgh'
	
	register Sinatra::AssetPack
	assets do
		serve '/assets', :from => 'public'
		
		js :app,
		[
			'/assets/js/jquery*.js',
			'/assets/js/filtrify.js',
			'/assets/js/login.js',
			'/assets/js/register.js',
			'/assets/js/highlight.js',
			'/assets/js/updateprivacy.js'
		]
		
		css :app,
		[
			'/assets/css/header.css',
			'/assets/css/login.css',
			'/assets/css/button.css',
			'/assets/css/home.css',
			'/assets/css/register.css',
			'/assets/css/timeline.css',
			'/assets/css/filtrify.css'
		]
		
		# build asset packages on app startup
		# rather than when they are first requested
		prebuild true
	end
	
end

require_relative 'models/init'
require_relative 'helpers/init'
require_relative 'routes/init'