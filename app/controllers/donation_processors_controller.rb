class DonationProcessorsController < ApplicationController

  before_action :ensure_admin


  def index

    @distributions = Distribution.all.order('created_at DESC')

  end

  def new

    @donation = Distribution.find(params[:distribution_id])

  end

  def create
    @donation = Distribution.find(params[:id])
    @donation.check_number = params[:check_number]
    @donation.cut_by = "#{kenny_loggins.first_name} #{kenny_loggins.last_name}"
    @donation.date_cut = DateTime.now.utc
    @donation.save!
    redirect_to donation_processors_path
  end

  private

end