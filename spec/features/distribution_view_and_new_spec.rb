feature "View Index and Create Distributions" do

  before(:each) do
    create_charity("United Way")
    create_charity("Red Cross")
  end

  scenario "As a visitor, I should NOT be able to view a history of distributions" do
    visit "/user/distributions"
    expect(page).to have_css("#homepage")
  end

  scenario "As a visitor, I should not be able to visit the new distributions page directly via typing in a URL" do
    visit "/user/distributions/new"
    expect(page).to have_css("#homepage")
  end

  context "As a logged in user," do

    before(:each) do
      create_user_and_make_deposit("Stephen", 40)
      visit "/"
      login_user("Stephen")
    end

    scenario "I should be able to view my history of distributions" do
      distribute_funds_from_my_account(10, "United Way")
      distribute_funds_from_my_account(20, "Red Cross")
      # #can't test this because 'show distr history is in the navbar nested in a jscript dropdown
      # click_on "Show Distribution History"
      # expect(page).to have_css("#index_distributions")
      # expect(page).to have_content("$100")
      # expect(page).not_to have_content("$10000")
      # expect(page).to have_content("$200")
    end

    scenario "I should not be able to make a distribution that is not in a $10 increment" do
      distribute_funds_from_my_account(9, "United Way")
      expect(page).to have_content("All distributions must be in increments of $#{Chip::CHIP_VALUE}.")
    end

    scenario "I can distribute funds from my account that are in proper $10 increments" do
      distribute_funds_from_my_account(10, "United Way")
      expect(page).to have_css("#show_dashboards")
      expect(page).to have_content("Thank you for distributing $10 from your account to United Way")
      expect(page.find("#deposits")).to have_content("$40")
      expect(page.find("#distributions")).to have_content("$10")
      expect(page.find("#distributions")).not_to have_content("$1000")
      expect(page.find("#net_amount")).to have_content("$30")
      distribute_funds_from_my_account(20, 'Red Cross')
      expect(page).to have_content("Thank you for distributing $20 from your account to Red Cross")
      expect(page.find("#deposits")).to have_content("$40")
      expect(page.find("#distributions")).to have_content("$30")
      expect(page.find("#net_amount")).to have_content("$10")
    end

    scenario "#I can not distribute more dollars than are currently available in my account" do
      distribute_funds_from_my_account(50, "United Way")
      expect(page).to have_css("#new_distributions")
      expect(page).to have_content("You don't have sufficient funds for the size of this distribution.  Unless you fund your account, the maximum you can distribute is $40")
    end

  end

end
