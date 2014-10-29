class DollarLocatorsController < ApplicationController

  def show
    @dollar_locator = DollarLocator.new(kenny_loggins)
  end


end