describe Chip do
  before(:each) do
   @user = User.create(email: "seth.geyer@gmail.com", password: "seth")
   @account = Account.create(user_id: @user.id, amount: 0)
   @chip = Chip.new


  end

  describe "#purchase" do
    before(:each) do
      @deposit = Deposit.create(account_id: @account.id, amount: 10000, cc_number: 1234567, exp_date: "2016-07-31", name_on_card: "Seth W Geyer", cc_type: "Visa", date_created: "2014-07-31")
    end

    it "converts the deposited amount to chips" do
      expect(Chip.all.count).to eq(0)
      @chip.purchase(@user.id, @account.id, @deposit.amount, @deposit.date_created, "available")
      expect(Chip.all.count).to eq(10)
      expect(Chip.first.account_id).to eq(@account.id)
      expect(Chip.first.owner_id).to eq(@user.id)
    end
  end


  describe "#cash_out" do
    before(:each) do
      @chip.purchase(@user.id, @account.id, 20000, "2014-07-12", "available" )
      @charity = Charity.create(name: "Red Cross")
    end

    it "cashes out the chips upon distribution of dollars" do
      available_chips = Chip.where(account_id: @account.id).where(status: "available")
      expect(available_chips.count).to eq(20)
      @distribution = Distribution.create(account_id: @account.id, amount: 11000, charity_id: @charity.id, date: "2014-08-30" )
      @chip.cash_out(@account.id, @distribution.amount, @distribution.date, @distribution.charity.id)
      available_chips = Chip.where(account_id: @account.id).where(status: "available")
      expect(available_chips.count).to eq(9)
      distributed_chips = Chip.where(account_id: @account.id).where(status: "distributed")
      expect(distributed_chips.count).to eq(11)
      expect(Chip.first.charity_id).to eq(@charity.id)
    end
  end

  describe "#change_status_to_wager" do
    before(:each) do
      @chip.purchase(@user.id, @account.id, 20000, "2014-07-12", "available" )
      @wageree = User.create(email: "a@gmail.com", password:"pong")

    end
    it "changes the status of the chips to wagered" do
      available_chips = Chip.where(account_id: @account.id).where(status: "available")
      expect(available_chips.count).to eq(20)
      @proposed_wager = ProposedWager.create(account_id: @account.id, title: "Pong Match", date_of_wager: "2014-08-14", details: "A vs. S", amount: 2000, wageree_id: @wageree.id)
      @chip.change_status_to_wager(@proposed_wager.account.id, @proposed_wager.amount )
      available_chips = Chip.where(account_id: @account.id).where(status: "available")
      expect(available_chips.count).to eq(18)
      wagered_chips = Chip.where(account_id: @account.id).where(status: "wagered")
      expect(wagered_chips.count).to eq(2)
    end
  end

  describe "#convert_ dollars" do
    it "converts dollars into the equivalent numbrer of chips" do
      chip_equivalancey = @chip.convert_from_pennies(12000)
      expect(chip_equivalancey).to eq(12)
    end
  end

  describe "find_the_available" do
    before(:each) do
      @chip.purchase(@user.id, @account.id, 20000, "2014-07-12", "available" )
      @chip.purchase(@user.id, @account.id, 1000, "2014-07-12", "wagered" )
      @chip.purchase(@user.id, @account.id, 5000, "2014-07-12", "distributed" )
    end

    it "returns a all chips that have not been distributed or wagered" do
      expect(Chip.all.count).to eq(26)
      available_chips = @chip.find_the_available(@account.id)
      expect(available_chips.count).to eq(20)
    end
  end



end