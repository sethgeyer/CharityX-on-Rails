module ApplicationHelper

  def full_name(user)
    "#{user.first_name} #{user.last_name}"
  end

  def humanized_eastern_time(utc_time)
    "#{utc_time.in_time_zone("Eastern Time (US & Canada)").strftime("%a %e-%b-%y %l:%M %p")} (ET)"
  end


  def humanized_eastern_date(utc_time)
    "#{utc_time.in_time_zone("Eastern Time (US & Canada)").strftime("%a %e-%b-%y")}"
  end

  def humanized_eastern_clock(utc_time)
    "#{utc_time.in_time_zone("Eastern Time (US & Canada)").strftime("%l:%M %p")} (ET)"
  end


end
