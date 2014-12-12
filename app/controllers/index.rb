

get '/' do
	@username = nil
	@user = nil
  erb :sign_in
end

post '/sessions' do 
	user = User.find_or_create_by(username: params[:username])
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

		@lasttenloc = Location.where(user_id: @user.id).order(:created_at).reverse_order.limit(10)


		# weatherhistory
		forecasting = Client.new
		forecastAPIkey = "afcc7a0db1d5eef67ebc4e50464b1bff"
		sevenyears = 220924835


		if @lastloc != nil

			year07 = JSON.parse(forecasting.get("https://api.forecast.io/forecast/"+forecastAPIkey+"/"+@lastloc.latitude.to_s+","+@lastloc.longitude.to_s+","+((@lastloc.date)-(sevenyears)).to_s).body)
			# raise year07.inspect
			@year07temp =year07["currently"]["temperature"] 
			@year07time =year07["currently"]["time"] 

			year00 = JSON.parse(forecasting.get("https://api.forecast.io/forecast/"+forecastAPIkey+"/"+@lastloc.latitude.to_s+","+@lastloc.longitude.to_s+","+((@lastloc.date)-(sevenyears*2)).to_s).body)
			@year00temp =year00["currently"]["temperature"] 
			@year00time =year00["currently"]["time"] 
			
			@history = [
				{date: Time.at(@year07time).strftime("%B, %Y"), temperature: @year07temp.to_i},
				{date: Time.at(@year00time).strftime("%B, %Y"), temperature: @year00temp.to_i}]


			# @history = [["Date", "Temperature"], [@year07time, @year07temp], [@year00time, @year00temp]]

			# year93 = JSON.parse(forecasting.get("https://api.forecast.io/forecast/"+forecastAPIkey+"/"+@lastloc.latitude.to_s+","+@lastloc.longitude.to_s+","+((@lastloc.date)-(sevenyears*3)).to_s).body)
			# @year93temp =year93["currently"]["temperature"] 

			# year86 = JSON.parse(forecasting.get("https://api.forecast.io/forecast/"+forecastAPIkey+"/"+@lastloc.latitude.to_s+","+@lastloc.longitude.to_s+","+((@lastloc.date)-(sevenyears*4)).to_s).body)
			# @year86temp =year86["currently"]["temperature"] 

			# year79 = JSON.parse(forecasting.get("https://api.forecast.io/forecast/"+forecastAPIkey+"/"+@lastloc.latitude.to_s+","+@lastloc.longitude.to_s+","+((@lastloc.date)-(sevenyears*5)).to_s).body)
			# @year79temp =year79["currently"]["temperature"] 
			
			# year72 = JSON.parse(forecasting.get("https://api.forecast.io/forecast/"+forecastAPIkey+"/"+@lastloc.latitude.to_s+","+@lastloc.longitude.to_s+","+((@lastloc.date)-(sevenyears*6)).to_s).body)
			# @year72temp =year72["currently"]["temperature"] 



		end

		erb :weather
	end
end

post '/weather' do 
	location = Location.create!(params[:location])

	geocoding = Client.new

	geoAPIkey = "AIzaSyDLfYd67AmNAp9emgjXettuQLFz41EzbiI"

	# need to do this to get rid of white space and for API call

	@city = location.city.split
	
	if @city.count > 1
		@geocode = JSON.parse(geocoding.get("https://maps.googleapis.com/maps/api/geocode/json?address="+@city[0]+ @city[1]+",+"+location.state+"&key="+geoAPIkey).body)
	else
		@geocode = JSON.parse(geocoding.get("https://maps.googleapis.com/maps/api/geocode/json?address="+@city[0]+",+"+location.state+"&key="+geoAPIkey).body)
	end

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

	# @year07 = JSON.parse(forecasting.get("https://api.forecast.io/forecast/"+forecastAPIkey+"/"+@lat.to_s+","+@lng.to_s+","+((location.date)-(sevenyears)).to_s).body)
	# @year00 = JSON.parse(forecasting.get("https://api.forecast.io/forecast/"+forecastAPIkey+"/"+@lat.to_s+","+@lng.to_s+","+((location.date)-(sevenyears*2)).to_s).body)
	# @year93 = JSON.parse(forecasting.get("https://api.forecast.io/forecast/"+forecastAPIkey+"/"+@lat.to_s+","+@lng.to_s+","+((location.date)-(sevenyears*3)).to_s).body)
	# @year86 = JSON.parse(forecasting.get("https://api.forecast.io/forecast/"+forecastAPIkey+"/"+@lat.to_s+","+@lng.to_s+","+((location.date)-(sevenyears*4)).to_s).body)
	# @year79 = JSON.parse(forecasting.get("https://api.forecast.io/forecast/"+forecastAPIkey+"/"+@lat.to_s+","+@lng.to_s+","+((location.date)-(sevenyears*5)).to_s).body)
	# @year72 = JSON.parse(forecasting.get("https://api.forecast.io/forecast/"+forecastAPIkey+"/"+@lat.to_s+","+@lng.to_s+","+((location.date)-(sevenyears*6)).to_s).body)

	# raise location.inspect

	redirect '/profile'
end

#-----SESSIONS-------------

get '/sessions/new' do 
end





