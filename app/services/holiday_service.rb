require 'faraday'
require 'json'

class HolidayService
  attr_reader :next_3_holidays

  def initialize
    @next_3_holidays = get_next_3_holidays
  end

  def get_next_3_holidays
    resp = Faraday.get("https://date.nager.at/Api/v2/NextPublicHolidays/US")
    JSON.parse(resp.body, symbolize_names: true)[0..2]
  end
end
