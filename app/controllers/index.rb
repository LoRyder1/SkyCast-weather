

get '/' do
	@username = nil
  erb :index
end

post '/sessions' do 
	user = User.find_by(username: params[:username])
	if user
		session[:user_id] = user.id
		redirect '/profile'
	else
		@error = "Invalid username"
		redirect '/'
	end
end

get '/profile' do 
	if session[:user_id] == nil
		redirect '/'
	else
		@user = User.find(session[:user_id])
		@location = Location.new
		erb :weather
	end
end

post '/weather' do 
	location = Location.create!(params[:location])

	geocoding = ApiCall.new

	APIKey = "AIzaSyDLfYd67AmNAp9emgjXettuQLFz41EzbiI"

	@geocode = JSON.parse(geocoding.get("https://maps.googleapis.com/maps/api/geocode/json?address="+location.city+",+"+location.state+"&key="+APIKey).body)

	# raise @geocode["results"].inspect
	@geolocation = @geocode["results"][0]["geometry"]["location"]
	@lat = @geolocation["lat"]
	@lng = @geolocation["lng"]

	location.update_attributes(latitude: @lat, longitude: @lng)

	# raise location.inspect

	redirect '/profile'
end

#-----SESSIONS-------------

get '/sessions/new' do 
end





