

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
		@weather = @lastloc.weathers[0] unless @lastloc == nil
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

	forecastAPIkey = "afcc7a0db1d5eef67ebc4e50464b1bff"

	@forecast = JSON.parse(forecasting.get("https://api.forecast.io/forecast/"+forecastAPIkey+"/"+@lat.to_s+","+@lng.to_s).body)

	

	# raise @forecast["currently"].inspect

	@currentweather = @forecast["currently"]

	weather = Weather.create!(location_id: location.id, temperature: @currentweather["temperature"], clouds: @currentweather["cloudCover"], icon: @currentweather["icon"])

	sevenyears = 220924835

	@year07 = JSON.parse(forecasting.get("https://api.forecast.io/forecast/"+forecastAPIkey+"/"+@lat.to_s+","+@lng.to_s+","+((location.date)-(sevenyears)).to_s).body)
	@year00 = JSON.parse(forecasting.get("https://api.forecast.io/forecast/"+forecastAPIkey+"/"+@lat.to_s+","+@lng.to_s+","+((location.date)-(sevenyears*2)).to_s).body)
	@year93 = JSON.parse(forecasting.get("https://api.forecast.io/forecast/"+forecastAPIkey+"/"+@lat.to_s+","+@lng.to_s+","+((location.date)-(sevenyears*3)).to_s).body)
	@year86 = JSON.parse(forecasting.get("https://api.forecast.io/forecast/"+forecastAPIkey+"/"+@lat.to_s+","+@lng.to_s+","+((location.date)-(sevenyears*4)).to_s).body)
	@year79 = JSON.parse(forecasting.get("https://api.forecast.io/forecast/"+forecastAPIkey+"/"+@lat.to_s+","+@lng.to_s+","+((location.date)-(sevenyears*5)).to_s).body)
	@year72 = JSON.parse(forecasting.get("https://api.forecast.io/forecast/"+forecastAPIkey+"/"+@lat.to_s+","+@lng.to_s+","+((location.date)-(sevenyears*6)).to_s).body)

	# raise location.inspect

	redirect '/profile'
end

#-----SESSIONS-------------

get '/sessions/new' do 
end





