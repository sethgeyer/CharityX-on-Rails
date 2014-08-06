class DistributionsController < ApplicationController
  def new
    @distribution = Distribution.new
  end
end