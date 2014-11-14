require 'rails_helper'
require 'capybara/rails'

describe Chip do
  before(:each) do
    @user = User.create!(email: "seth.geyer@gmail.com", password: "password", username: "seth", first_name: "seth", last_name: "geyer")
  end

  describe "#convert_currency_to_chips" do
    before(:each) do
      @deposit = Deposit.create!(user_id: @user.id, amount: 10000, cc_number: 1234567, exp_date: "2016-07-31", name_on_card: "Seth W Geyer", cc_type: "Visa", date_created: "2014-07-31")
    end

    it "converts the deposited amount to chips" do
      expect(Chip.all.count).to eq(0)
      Chip.convert_currency_to_chips(@user.id, @deposit.amount, @deposit.date_created, "available")
      expect(Chip.all.count).to eq(@deposit.amount / 100 / Chip::CHIP_VALUE)
      expect(Chip.first.user_id).to eq(@user.id)
      expect(Chip.first.owner_id).to eq(@user.id)
    end
  end


  describe "#mark_as_distributed_to_charity" do
    before(:each) do
      Chip.convert_currency_to_chips(@user.id, 20000, "2014-07-12", "available" )
      @charity = create_charity("Red Cross")
    end

    it "marks the chips as distributed upon distribution of dollars" do
      available_chips = Chip.where(user_id: @user.id).where(status: "available")
      expect(available_chips.count).to eq(20000 / 100 / Chip::CHIP_VALUE)
      @distribution = Distribution.create(user_id: @user.id, amount: 11000, charity_id: @charity.id, date: "2014-08-30" )
      Chip.mark_as_distributed_to_charity(@user.id, @distribution.amount, @distribution.date, @distribution.charity.id)
      available_chips = Chip.where(user_id: @user.id).where(status: "available")
      expect(available_chips.count).to eq((20000 - 11000) / 100 / Chip::CHIP_VALUE)
      distributed_chips = Chip.where(user_id: @user.id).where(status: "distributed")
      expect(distributed_chips.count).to eq(11000 / 100 / Chip::CHIP_VALUE)
      expect(Chip.first.charity_id).to eq(@charity.id)
    end

    it "distributes the 'won' chips before distributing the users owns chips" do
      @other_user = User.create!(email: "larry.geyer@gmail.com", password: "password", username: "larry", first_name: "larry", last_name: "geyer")
      available_chips = Chip.where(user_id: @user.id).where(status: "available")
      expect(available_chips.count).to eq(20)
      @other_users_lost_chips = Chip.create(user_id: @user.id, owner_id: @other_user.id, status: "available", created_at: "2013-07-12")
      expect(available_chips.count).to eq(21)

      @distribution = Distribution.create(user_id: @user.id, amount: 1000, charity_id: @charity.id, date: "2014-08-30" )
      Chip.mark_as_distributed_to_charity(@user.id, @distribution.amount, @distribution.date, @distribution.charity.id)
      now_available_chips = Chip.where(user_id: @user.id).where(status: "available")
      expect(now_available_chips.count).to eq(20)
      @other_users_lost_and_distributed_chips = @user.chips.where(owner_id: @other_user.id).first
      expect(@other_users_lost_and_distributed_chips.status).to eq("distributed")

    end



  end

  describe "#change_status_to_wager" do
    before(:each) do
      Chip.convert_currency_to_chips(@user.id, 20000, "2014-07-12", "available" )
      @wageree = User.create(email: "a@gmail.com", password:"pong")

    end
    it "changes the status of the chips to wagered" do
      available_chips = Chip.where(user_id: @user.id).where(status: "available")
      expect(available_chips.count).to eq(20000 / 100 / Chip::CHIP_VALUE)
      @wager = Wager.create(user_id: @user.id, title: "Pong Match", date_of_wager: "2014-08-14", details: "A vs. S", amount: 2000, wageree_id: @wageree.id)
      Chip.set_status_to_wagered(@wager.user.id, @wager.amount )
      available_chips = Chip.where(user_id: @user.id).where(status: "available")
      expect(available_chips.count).to eq((20000 - 2000) / 100 / Chip::CHIP_VALUE)
      wagered_chips = Chip.where(user_id: @user.id).where(status: "wagered")
      expect(wagered_chips.count).to eq(2000 / 100 / Chip::CHIP_VALUE)
    end
  end

  describe "#convert_ dollars" do
    it "converts dollars into the equivalent numbrer of chips" do
      chip_equivalancey = Chip.convert_from_pennies_to_chips(12000)
      expect(chip_equivalancey).to eq(12000 / 100 / Chip::CHIP_VALUE)
    end
  end

  describe "find_the_available" do
    before(:each) do
      Chip.convert_currency_to_chips(@user.id, 20000, "2014-07-12", "available" )
      Chip.convert_currency_to_chips(@user.id, 1000, "2014-07-12", "wagered" )
      Chip.convert_currency_to_chips(@user.id, 5000, "2014-07-12", "distributed" )
    end

    it "returns a all chips that have not been distributed or wagered" do
      expect(Chip.all.count).to eq(26000 / 100 / Chip::CHIP_VALUE)
      available_chips = Chip.find_the_available(@user.id)
      expect(available_chips.count).to eq(20000 / 100 / Chip::CHIP_VALUE)
    end
  end



end
