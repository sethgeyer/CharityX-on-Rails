class GivingSummariesController < ApplicationController

  def show
    @dollar_locator = GivingSummary.new(kenny_loggins)
    @dashboard = Dashboard.new
  end


end