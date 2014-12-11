

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
		@weather = Weather.new
		@lastloc = @user.locations.last
		erb :weather
	end
end

post '/weather' do 
	location = Location.create!(params[:location])

	geocoding = Client.new

	geoAPIkey = "AIzaSyDLfYd67AmNAp9emgjXettuQLFz41EzbiI"

	@geocode = JSON.parse(geocoding.get("https://maps.googleapis.com/maps/api/geocode/json?address="+location.city+",+"+location.state+"&key="+geoAPIkey).body)

	# raise @geocode["results"].inspect
	@geolocation = @geocode["results"][0]["geometry"]["location"]
	@lat = @geolocation["lat"]
	@lng = @geolocation["lng"]

	location.update_attributes(latitude: @lat, longitude: @lng)



	forecasting = Client.new

	castAPIkey = "afcc7a0db1d5eef67ebc4e50464b1bff"

	@forecast = JSON.parse(forecasting.get("https://api.forecast.io/forecast/"+castAPIkey+"/37.8267,-122.423"
).body)

	# raise @forecast["currently"].inspect
	

	# raise @forecast["currently"].inspect

	@currentweather = @forecast["currently"]

	weather = Weather.create!(location_id: location.id, temperature: @currentweather.temperature, clouds: @currentweather.cloudCover, icon: @currentweather.icon)

	# raise location.inspect

	redirect '/profile'
end

#-----SESSIONS-------------

get '/sessions/new' do 
end





