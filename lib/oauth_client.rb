require 'uri'
require 'net/http'
require 'net/https'
require 'simple_oauth'
require 'json'

class ApiCall

  def get(url)
    # create the HTTP GET request
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Get.new(URI(url))


    # set the Authorization Header using the oauth helper

    # connect to the server and send the request
    response = http.request(request)
    response.body

    response
  end

end





