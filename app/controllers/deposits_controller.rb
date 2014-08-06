class DepositsController < ApplicationController

  def new
    @deposit = Deposit.new
  end
end