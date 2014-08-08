feature "View Index and Create Distribution" do
  before(:each) do
    visit "/charities/new"
    complete_application("United Way")
    visit "/charities/new"
    complete_application("Red Cross")
  end

  scenario "As a visitor, I should NOT be able to view a history of deposits" do
    # visit "/deposits"
    visit "/accounts/1/deposits"
    expect(page).to have_css("#homepage")
  end

  scenario "As a user, I should be able to view my history of distributions" do
    fill_in_registration_form("Stephen")
    fund_my_account_with_a_credit_card(400)
    fund_my_account_with_a_credit_card(500)
    distribute_funds_from_my_account(100, "United Way")
    distribute_funds_from_my_account(200, "Red Cross")
    click_on "Show Distribution History"

    expect(page).to have_css("#index_distributions")
    expect(page).to have_content("$100")
    expect(page).not_to have_content("$10000")
    expect(page).to have_content("$200")
  end

  scenario "As a visitor, I should not be able to visit the new distributions page directly via typing in a uRL" do
    visit "/accounts/1/distributions/new"
    expect(page).to have_css("#homepage")
  end

  scenario "As a user I can distribute funds from my account" do
    fill_in_registration_form("Stephen")
    fund_my_account_with_a_credit_card(400)
    distribute_funds_from_my_account(100, "United Way")

    expect(page).to have_css("#show_users")
    expect(page).to have_content("Thank you for distributing $100 from your account to United Way")
    expect(page.find("#deposits")).to have_content("$400")
    expect(page.find("#distributions")).to have_content("$100")
    expect(page.find("#distributions")).not_to have_content("$10000")
    expect(page.find("#net_amount")).to have_content("$300")

    distribute_funds_from_my_account(50, 'Red Cross')

    expect(page).to have_content("Thank you for distributing $50 from your account to Red Cross")
    expect(page.find("#deposits")).to have_content("$400")
    expect(page.find("#distributions")).to have_content("$150")
    expect(page.find("#net_amount")).to have_content("$250")
  end

end
