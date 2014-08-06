class ProposedWagersController < ApplicationController

  def new
    @proposed_wager = ProposedWager.new
  end
end