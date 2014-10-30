feature "dollar locator view" do

  before(:each) do
    @another_user = create_user_and_make_a_deposit_to_their_account("Alexander", 300)
    @the_user = create_user_and_make_a_deposit_to_their_account("Stephen", 300, Date.today.days_ago(3))
    create_an_existing_accepted_wager(@the_user.first_name, @another_user.first_name, 10)
    create_a_distribution(@the_user.first_name, 30)
    visit "/"
    login_user("Stephen")

  end

  scenario "As a user, I can view the 'Where are my dollars' table" do
    visit user_dollar_locator_path
    expect(page).to have_content("$300")
  end

  scenario "As a user, I can see my dollars actively wagered" do
    visit user_dollar_locator_path
    expect(page).to have_content("$10")
  end

  scenario "As a user, I can see the dollars I've personally distributed" do
    visit user_dollar_locator_path
    expect(page).to have_content("$30")
  end

  scenario "As a user, I can see my net account balance" do
    visit user_dollar_locator_path
    expect(page).to have_content("$260")
  end

  scenario "As a user, I can see my gains from wagers" do
    click_on "Logout"
    login_user("Alexander")
    click_on "I Lost"
    click_on "Logout"
    login_user("Stephen")
    visit user_dollar_locator_path
    expect(page).to have_content("$10")
  end

  context "As a user that lost a wager" do
    before(:each) do
      click_on "I Lost"
    end

    scenario "I can see my losses from wagers" do
      visit user_dollar_locator_path
      expect(page).to have_content("$(10) ")
    end

    scenario "I can see that my lost wager dollars are in another's account" do
      visit user_dollar_locator_path
      expect(page.find(".losses-in-others-accounts")).to have_content("$10")
    end

    scenario "I can see that my lost wager dollars have been distributed to a charity" do
      click_on "Logout"
      login_user("Alexander")
      distribute_funds_from_my_account(10, "Red Cross")
      click_on  "Logout"
      login_user("Stephen")
      visit user_dollar_locator_path
      expect(page.find(".losses-in-others-accounts")).to have_content("$0")
      expect(page.find(".losses-distributed")).to have_content("$10")

    end

  end

end