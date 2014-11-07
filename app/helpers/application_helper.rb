module ApplicationHelper

  def full_name(user)
    "#{user.first_name} #{user.last_name}"
  end

  def timezone_adjusted_datetime(utc_time)
    "#{utc_time.in_time_zone(kenny_loggins.timezone).strftime("%a %e-%b-%y %l:%M %p")} (loc)"
  end


  def timezone_adjusted_date(utc_time)
    "#{utc_time.in_time_zone(kenny_loggins.timezone).strftime("%a %e-%b-%y")}"
  end

  def timezone_adjusted_clock(utc_time)
    "#{utc_time.in_time_zone(kenny_loggins.timezone).strftime("%l:%M %p")} (loc)"
  end


end
