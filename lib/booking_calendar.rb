require_relative 'database_connection'
require 'date'

class BookingCalendar
  def initialize(space_id:, start_date:, end_date:)
    @space_id = space_id
    @start_date = start_date
    @end_date = end_date
  end

  def self.create(space_id:, start_date:, end_date:)
    finish = end_date
    start = start_date
    space_id = space_id
    DatabaseConnection.query(
      "INSERT INTO dates(date, available, space_id)
      SELECT i::date, 'TRUE', #{space_id}
      FROM generate_series(
      '#{start}'::date,
      '#{finish}'::date,
      '1 day') AS t(i);", []
    )
  end

  def self.availability(space_id:)
    result = DatabaseConnection.query(
      "SELECT date FROM dates
      WHERE space_id = '#{space_id}'
      AND available = TRUE;", []
    )
    result.map do |request|
      request['date']
    end
  end
end
