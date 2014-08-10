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
    expect(page.find("#wagers")).to have_content(100)
    expect(page.find("#net_amount")).to have_content(300)
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
  end



end
