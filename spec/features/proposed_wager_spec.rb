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
    expect(page.find("#proposed_wagers_table")).to have_link("Withdraw")
    expect(page.find("#wagers")).to have_content(100)
    expect(page.find("#net_amount")).to have_content(300)
  end

  # scenario "As a wagerer, I can not create a proposed wager if I don't have adequate funds" do
  #   fill_in_registration_form("AlexWageree")
  #   fund_my_account_with_a_credit_card(1000)
  #   click_on "Logout"
  #   fill_in_registration_form("StephenWagerer")
  #   fund_my_account_with_a_credit_card(0)
  #   click_on "Create a Wager"
  #   expect(page).to have_content("Your account has a $0 balance.  You must fund your account before you can wager.")
  # end

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


  scenario "As a wageree, I can accept a proposed_wager" do
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

end
