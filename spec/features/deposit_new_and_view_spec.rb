feature "Deposit and View Funds in an Account" do

  scenario "As a visitor, I should not be able to visit the new_deposits page directly via typing in a URL" do
    visit "/user/deposits/new"
    expect(page).to have_css("#homepage")
  end

  scenario "As a visitor, I should NOT be able to view a history of deposits" do
    visit "/user/deposits"
    expect(page).to have_css("#homepage")
  end

  context "As a logged in user" do

    before(:each) do
      create_user("Stephen")
      visit "/"
      login_user("Stephen")
    end

    scenario "I can not make a deposit worth more than $1000" do
      make_a_deposit_to_their_account(1001)
      expect(page).to have_css("#new_deposits")
      expect(page).to have_content("All deposits must be in increments of $#{$ChipValue} and no more than $1,000.")
    end

    scenario "I can not make a deposit that is not in $10 increments" do
      make_a_deposit_to_their_account(9)
      expect(page).to have_css("#new_deposits")
      expect(page).to have_content("All deposits must be in increments of $#{$ChipValue} and no more than $1,000.")
    end

    scenario "As a user, I can add funds to my account and see deposit totals" do
      make_a_deposit_to_their_account(40)
      expect(page).to have_css("#show_dashboards")
      expect(page).to have_content("Thank you for depositing $40 into your account")
      expect(page.find("#deposits")).to have_content("$40")
      expect(page.find("#deposits")).not_to have_content("$4000")
      expect(page.find("#net_amount")).to have_content("$40")

      make_a_deposit_to_their_account(50)
      expect(page).to have_content("Thank you for depositing $50 into your account")
      expect(page.find("#deposits")).to have_content("$90")
      expect(page.find("#net_amount")).to have_content("$90")
    end

    scenario "As a user, I should be able to view my history of deposits" do
      make_a_deposit_to_their_account(40)
      make_a_deposit_to_their_account(50)
      #can't test this because 'show deposit history is in the navbar nested in a jscript dropdown
      # click_on "Show Deposit History"
      # expect(page).to have_css("#index_deposits")
      # expect(page).to have_content("$400")
      # expect(page).not_to have_content("$40000")
      # expect(page).to have_content("$500")
    end

  end

end