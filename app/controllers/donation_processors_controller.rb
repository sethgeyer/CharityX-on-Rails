class DonationProcessorsController < ApplicationController

  before_action :ensure_admin


  def index

    @distributions = Distribution.all

  end

  private





end