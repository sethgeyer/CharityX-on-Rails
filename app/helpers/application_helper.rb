module ApplicationHelper

  def full_name(user)
    "#{user.first_name} #{user.last_name}"
  end

  def timezone_adjusted_datetime(utc_time, user = kenny_loggins)
    "#{utc_time.in_time_zone(user.timezone).strftime("%a %e-%b-%y %l:%M %p")} (loc)"
  end

  def timezone_adjusted_date(utc_time, user = kenny_loggins)
    "#{utc_time.in_time_zone(user.timezone).strftime("%a %e-%b-%y")}"
  end

  def timezone_adjusted_clock(utc_time, user = kenny_loggins)
    "#{utc_time.in_time_zone(user.timezone).strftime("%l:%M %p")} (loc)"
  end
end
