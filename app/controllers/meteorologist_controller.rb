require 'open-uri'

class MeteorologistController < ApplicationController
  def street_to_weather_form
    # Nothing to do here.
    render("meteorologist/street_to_weather_form.html.erb")
  end

  def street_to_weather
    @street_address = params[:user_street_address]

    # ==========================================================================
    # Your code goes below.
    #
    # The street address that the user typed is in the variable @street_address.
    # ==========================================================================

    url = "http://maps.googleapis.com/maps/api/geocode/json?address="
    street_address = @street_address.split(" ")

    street_address.each do |address|
      url = url + address + "+"
    end

    url[url.length - 1] = "&"
    url = url + "sensor=false"

    parsed_data = JSON.parse(open(url).read)
    @lat = parsed_data["results"][0]["geometry"]["location"]["lat"]
    @lng = parsed_data["results"][0]["geometry"]["location"]["lng"]

    url = "https://api.darksky.net/forecast/cf3f417be1f8e5c64b21e6ee3a7de9f3/"
    url = url + @lat.to_s + "," + @lng.to_s

    parsed_data = JSON.parse(open(url).read)
    @current_temperature = parsed_data["currently"]["temperature"]

    @current_summary = parsed_data["currently"]["summary"]

    @summary_of_next_sixty_minutes = parsed_data["minutely"]["summary"]

    @summary_of_next_several_hours = parsed_data["hourly"]["summary"]

    @summary_of_next_several_days = parsed_data["daily"]["summary"]


    render("meteorologist/street_to_weather.html.erb")
  end
end
