feature "User Show Page" do
  before(:each) do
    fill_in_registration_form("Stephen")
  end

  scenario "As a logged in user I can view my account details page" do
    expect(page).to have_css("#deposits")
    expect(page).to have_css("#distributions")
    expect(page).to have_css("#net_amount")
  end

  scenario "As a logged_in user I can link to the new deposits page to fund my account" do
    click_on "Fund My Account"

    expect(page).to have_css("#new_deposits")
  end

  scenario "As a logged_in user I can link to the 'create a wager' page to create a wager" do
    click_on "Create a Wager"

    expect(page).to have_css("#new_proposed_wagers")
  end

  scenario "As a logged_in user I can link to the new distributions page to distribute funds from my account" do
    click_on "Distribute Funds"

    expect(page).to have_css("#new_distributions")
  end

  # scenario "non-logged in visitor attempts to visit show page" do
  #   visit "/users/50000"
  #
  #   expect(page).to have_content("You are not authorized to visit this page")
  #   expect(page).to have_css("#homepage")
  # end



end