feature "View and Create a Proposed Wagers" do

  scenario "As a visitor, I should not be able to visit the new proposed wager view directly via the URL " do
    visit "/accounts/1/proposed_wagers/new"

    expect(page).to have_css("#homepage")
  end

  scenario "As a user I can create a proposed wager" do
    register_users_and_create_a_wager("Alexander", "Stephen")
    expect(page).to have_css("#show_users")
    expect(page).to have_content("Your proposed wager has been sent to alexandery.")
    expect(page.find("#proposed_wagers_table")).to have_content("Ping Pong Match")
    expect(page.find("#proposed_wagers_table")).to have_content(100)
    expect(page.find("#proposed_wagers_table")).not_to have_content(10000)
    expect(page.find("#proposed_wagers_table")).to have_content("alexandery")
    expect(page.find("#proposed_wagers_table")).to have_content("w/wageree")
    expect(page.find("#proposed_wagers_table")).not_to have_link("Shake on it")
    expect(page.find("#proposed_wagers_table")).not_to have_button("Win") # _______________________
    expect(page.find("#proposed_wagers_table")).not_to have_button("Lose") # _______________________
    expect(page.find("#proposed_wagers_table")).not_to have_button("Draw") # _______________________

    expect(page.find("#proposed_wagers_table")).to have_link("Withdraw")
    expect(page.find("#wagers")).to have_content(100)
    expect(page.find("#net_amount")).to have_content(300)
  end

  scenario "As a wagerer, I can not bet more dollars than are currently available in my account" do
    fill_in_registration_form("AlexWageree")
    fund_my_account_with_a_credit_card(1000)
    click_on "Logout"
    fill_in_registration_form("StephenWagerer")
    fund_my_account_with_a_credit_card(400)
    click_on "Create a Wager"
    fill_in "proposed_wager_title", with: "Ping Pong Match between S & A"
    fill_in "proposed_wager_date_of_wager", with: "2014-07-31"
    fill_in "proposed_wager_details", with: "Game to 21, standard rules apply"
    fill_in "proposed_wager_amount", with: 500
    select "alexwagereey", from: "proposed_wager_wageree_id"
    click_on "Submit"
    expect(page).to have_css("#new_proposed_wagers")
    expect(page).to have_content("You don't have sufficient funds for the size of this wager.  Unless you fund your account, the maximum you can wager is $400")
  end

  scenario "As a user I can withdraw a proposed wager that has not yet been accepted" do
    register_users_and_create_a_wager("Alexander", "Stephen")
    expect(page.find("#wagers")).to have_content("$100")
    expect(page.find("#wagers")).to have_content("Chips:10")
    click_on "Withdraw"
    expect(page.find("#wagers")).to have_content("$0")
    expect(page.find("#wagers")).to have_content("Chips:0")


  end

  scenario "As a wagerer, I can not 'withdraw' a proposed wager if it has been accepted" do
    register_users_and_create_a_wager("Alexander", "Stephen")
    click_on "Logout"
    login_a_registered_user("Alexander")
    click_on "Shake on it"
    click_on "Logout"
    login_a_registered_user("Stephen")
    expect(page).to have_content("Ping Pong Match")
    expect(page).not_to have_link("Withdraw")
    expect(page.find("#wagers")).to have_content(100)
    expect(page.find("#wagers")).to have_content("Chips:10")
  end

  scenario "As a user I can see a proposed wager in which I'm the wageree" do
    register_users_and_create_a_wager("Alexander", "Stephen")
    click_on "Logout"
    login_a_registered_user("Alexander")
    expect(page.find("#proposed_wagers_table")).to have_content("Ping Pong Match")
    expect(page.find("#proposed_wagers_table")).to have_content(100)
    expect(page.find("#proposed_wagers_table")).not_to have_content(10000)
    expect(page.find("#proposed_wagers_table")).to have_content("stepheny")
    expect(page.find("#proposed_wagers_table")).to have_content("w/wageree")
    expect(page.find("#wagers")).to have_content(0)
  end


  scenario "As a wageree, I can accept a proposed_wager if I have sufficent funds to wager" do
    register_users_and_create_a_wager("Alexander", "Stephen")
    click_on "Logout"
    login_a_registered_user("Alexander")
    expect(page.find("#wagers")).to have_content("$0")

    click_on "Shake on it"

    expect(page).to have_css("#show_users")
    expect(page.find("#proposed_wagers_table")).not_to have_link("Shake on it")
    expect(page.find("#proposed_wagers_table")).to have_content("accepted")
    expect(page.find("#wagers")).to have_content(100)
    expect(page.find("#wagers")).to have_content("Chips:10")
    expect(page.find("#net_amount")).to have_content(900)
    expect(page.find("#net_amount")).to have_content(900)
  end

  scenario "As a wageree, I can NOT accept a proposed_wager if I don't have sufficient funds to wager" do
    visit "/charities/new"
    complete_application("United Way")
    register_users_and_create_a_wager("Alexander", "Stephen")
    click_on "Logout"
    login_a_registered_user("Alexander")

    distribute_funds_from_my_account(950, "United Way")
    click_on "Shake on it"

    expect(page).to have_css("#show_users")
    expect(page).to have_content("You don't have adequate funds to accept this wager.  Please add additional funds to your account.")
    expect(page.find("#net_amount")).to have_content("$50")

  end

  scenario "As a wagerer, I can identify myself as winning or losing a bet" do
    register_users_and_create_a_wager("Alexander", "Stephen")
    click_on "Logout"
    login_a_registered_user("Alexander")
    click_on "Shake on it"
    click_on "Logout"
    login_a_registered_user("Stephen")
    expect(page).to have_button("Win")
    expect(page).to have_button("Lose")
    expect(page).to have_button("Draw")

  end

  scenario "As a wageree, I can identify myself as winning or losing a bet" do
    register_users_and_create_a_wager("Alexander", "Stephen")
    click_on "Logout"
    login_a_registered_user("Alexander")
    click_on "Shake on it"
    expect(page).to have_button("Win")
    expect(page).to have_button("Lose")
    expect(page).to have_button("Draw")

  end

  scenario "As a wagerer that won the bet, I collect the money from the wageree" do
    register_users_and_create_a_wager("Alexander", "Stephen")
    click_on "Logout"
    login_a_registered_user("Alexander")
    click_on "Shake on it"
    click_on "Lose"
    click_on "Logout"
    login_a_registered_user("Stephen")
    expect(page).to have_content("You Won")
    expect(page).not_to have_link("Lose")
    expect(page).not_to have_link("Win")

    expect(page.find("#winnings")).to have_content(100)
    expect(page.find("#wagers")).to have_content("$0")
    expect(page.find("#wagers")).to have_content("Chips:0")
    # expect(page.find("#winnings")).to have_content("Chips:10")
    expect(page.find("#net_amount")).to have_content(500)
    expect(page.find("#net_amount")).to have_content("Chips:50")
  end

  scenario "As a wageree that lost the bet, I transfer the money to the wagerer" do
    register_users_and_create_a_wager("Alexander", "Stephen")
    click_on "Logout"
    login_a_registered_user("Alexander")
    click_on "Shake on it"
    click_on "Lose"
    click_on "Logout"
    login_a_registered_user("Stephen")
    expect(page).to have_content("You Won")
    expect(page).not_to have_link("Lose")
    expect(page).not_to have_link("Win")

    expect(page.find("#winnings")).to have_content(100)
    expect(page.find("#wagers")).to have_content("$0")
    expect(page.find("#wagers")).to have_content("Chips:0")
    # expect(page.find("#winnings")).to have_content("Chips:10")
    expect(page.find("#net_amount")).to have_content(500)
    expect(page.find("#net_amount")).to have_content("Chips:50")
  end



end
