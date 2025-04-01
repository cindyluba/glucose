class MembersController < ApplicationController
  def dashboard
    @member = Member.find(params[:id])
    @levels = @member.continuous_glucose_levels

    # Now calculate metrics (you can extract these into a service later)

    @avg_glucose = {
      week: average_glucose(6.days.ago.beginning_of_day, Time.current.end_of_day),
      month: average_glucose(Time.current.beginning_of_month, Time.current.end_of_month)
    }

    @prior_avg_glucose = {
      week: average_glucose(13.days.ago.beginning_of_day, 7.days.ago.end_of_day),
      month: average_glucose(Time.current.last_month.beginning_of_month, Time.current.last_month.end_of_month)
    }

    @time_above_range = {
      week: time_above_range(6.days.ago.beginning_of_day, Time.current.end_of_day),
      month: time_above_range(Time.current.beginning_of_month, Time.current.end_of_month)
    }

    @prior_time_above_range = {
      week: time_above_range(13.days.ago.beginning_of_day, 7.days.ago.end_of_day),
      month: time_above_range(Time.current.last_month.beginning_of_month, Time.current.last_month.end_of_month)
    }

    @time_below_range = {
      week: time_below_range(6.days.ago.beginning_of_day, Time.current.end_of_day),
      month: time_below_range(Time.current.beginning_of_month, Time.current.end_of_month)
    }

    @prior_time_below_range = {
      week: time_below_range(13.days.ago.beginning_of_day, 7.days.ago.end_of_day),
      month: time_below_range(Time.current.last_month.beginning_of_month, Time.current.last_month.end_of_month)
    }
  end

  private

  # timestamps in table is in utc
  # query the levels shifted 
  # last 7 day - from: start of day 6 days ago, end: today end of day
  # month - from: start of current moneth, end: end of day for the month
  def average_glucose(from, to)
    levels_in_range = @levels.select do |level|
      offset = Time.parse(level.tz_offset).utc_offset
      local_time = level.tested_at.getlocal(offset)
      from_shifted = from.getlocal(offset)
      to_shifted = to.getlocal(offset)
      local_time >= from_shifted && local_time <= to_shifted
    end
    return nil if levels_in_range.empty? # So the view can show "N/A"
    levels_in_range.sum(&:value).to_f / levels_in_range.size
  end

  def time_above_range(from, to)
    levels_in_range = @levels.select do |level|
      offset = Time.parse(level.tz_offset).utc_offset
      local_time = level.tested_at.getlocal(offset)
      from_shifted = from.getlocal(offset)
      to_shifted = to.getlocal(offset)
      local_time >= from_shifted && local_time <= to_shifted
    end
    return nil if levels_in_range.empty? # So the view can show "N/A"
    (levels_in_range.count { |level| level.value > 180 }.to_f / levels_in_range.size * 100).round(2)
  end

  def time_below_range(from, to)
    levels_in_range = @levels.where(tested_at:from..to)
    return nil if levels_in_range.empty? # So the view can show "N/A"
    (levels_in_range.count { |level| level.value < 70 }.to_f / levels_in_range.size * 100).round(2)

  end

end
