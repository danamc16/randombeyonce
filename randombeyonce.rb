require 'sinatra'
require 'sinatra/reloader'
require 'pry'

configure do
	enable :sessions
	_method = true
end

use Rack::MethodOverride

# 	edgLwyMS4tk, eiDTgnFnuMI, Lt9_1rGHxF4, WjxL5crGUcw

set = Hash.new{}

get '/' do
	session[:history] ||= {}
	result = "bpOSxM0rNPM"
	erb :index, :locals => {:history => session[:history], :result => result}
end

get '/sets' do
	session[:history] ||= {}
	if session[:history].keys.include?(params[:button])
		title = params[:button]
		redirect to('/sets/' + title)
	end
	erb :sets, :locals => {:history => session[:history]}
end


post '/sets' do
	session[:history] ||= {}
	vidlist = params[:vids].split(", ")
	if params[:button] == "Submit"
		combined = vidlist.push(params[:description])
		session[:history][params[:setname]] = combined
	end

	erb :sets, :locals => {:history => session[:history]}
end

get '/sets/:title' do
	
	insides = Marshal.load(Marshal.dump(session[:history][params[:title]]))
	insides.pop
	insides.shuffle!

	@first_vid = ''
	@rest_of_vids = ''

	insides.each do |video|
		if video == insides[0]
            @first_vid = video
        elsif video != insides[insides.length-1]
            @rest_of_vids << video + ','
        else
            @rest_of_vids << video
        end
	end

	first = @first_vid
    rest = @rest_of_vids

	vid_playlist = '<iframe width="750" height="500" src="https://www.youtube.com/v/' + @first_vid + '?version=3&loop=1&playlist=' + @rest_of_vids + '" frameborder="0" allowfullscreen></iframe>'

	title = params[:title]

	erb :setname, :locals => {:first => first, :rest => rest,:vid_playlist => vid_playlist,:title => params[:title], :history => session[:history]}
end

get '/sets/:title/edit' do
	title = params[:title]
	description = session[:history][title][(session[:history][title].length)-1]
	vidlist = Marshal.load(Marshal.dump(session[:history][title]))
	vidlist.pop
	string = ""
	vidlist.each do |vid|
		if vid == vidlist[0]
			string = vid
		else
			string = string + ", " + vid
		end
	end

	erb :edit, :locals => {:title => title, :description => description,:vidlist => vidlist, :string => string}
end

put '/sets/:title/edit' do

	title = params[:title]
	title_new = params[:title_new]
	session[:history][title_new] = session[:history].delete(title)
	description = params[:description]
	vidlist = params[:vidlist].split(', ')
	session[:history][title_new].replace(vidlist.push(description))
	redirect to('/sets/' + title_new)
	
	erb :edit, :locals => {:title => params[:title],:title_new => params[:title_new],:description => params[:description],:vidlist => params[:vidlist]}
end

delete '/sets/:title' do
	title = params[:title]
	session[:history].delete(title)
	redirect to('/sets')
	erb :setname, :locals => {:title => title}
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