require 'sinatra'
require 'sinatra/reloader'
require 'pry'

configure do
	enable :sessions
end

# sets => {
# 	"SETNAME" => {
# 		"name" => "SETNAME", "vidnums" =>
# 		["lLJf9qJHR3E","RB-RcX5DS5A"]
# 	}
# }

set = Hash.new{}

# get '/sets' do
# 	session[:history] ||=[]
# 	params[:setname]
#  	params[:vids]
# 	params[:description]

# 	erb :sets, :locals => {:history => session[:history]}
# end

get '/' do
	session[:history] ||= {}
	result = "bpOSxM0rNPM"
	erb :index, :locals => {:history => session[:history],
							:result => result}
end

get '/sets' do
	session[:history] ||= {}
	if session[:history].keys.include?(params[:button])
		title = params[:button]
		insides = Array.new
		session[:history][params[:button]]
		binding.pry
		insides.pop
		binding.pry
		result = insides[rand(0..(insides.length-1))]
		binding.pry
		redirect('/sets/' + title)
	end
	erb :sets, :locals => {:history => session[:history]}
end


post '/sets' do
	vidlist = params[:vids].split(", ")
	#vidlist is the array of videos
	if params[:button] == "Submit"
		combined = vidlist.push(params[:description])
		session[:history][params[:setname]] = combined
		#creates a hash that maps setname to the array vidlist
		#pushes description to the end of vidlist
	end


	#binding.pry
	erb :sets, :locals => {:result => result, :history => session[:history]}
end

get '/sets/:title' do
	erb :setname, :locals => {:title => params[:title], :history => session[:history]}
end


# HTTP Verb | URL | Controller | Action | used for | Must create View?
# --- | --- | --- | --- | --- | ---
# GET | /sets | Set | index | display all sets in an overview | Yes
# GET | /sets/new | Set | new | return an HTML form for creating a new set | Yes
# POST | /sets | Set | create | create a new set | No
# GET | /sets/beyonce | Set | show | display a specific set | Yes
# GET | /sets/beyonce/play | Set | a custom one! | play a specific set | Yes
# GET | /sets/beyonce/edit | Set | edit | return an HTML form for editing a set | Yes
# PUT | /sets/beyonce | Set | update | update a specific set | No
# DELETE | /sets/beyonce | Set | destroy | delete a specific set | Yes