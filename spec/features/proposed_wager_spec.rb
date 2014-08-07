feature "View and Create a Proposed Wagers" do

  scenario "As a visitor, I should not be able to visit the new proposed wager view directly via the URL " do
    visit "/proposed_wagers/new"

    expect(page).to have_content("You are not authorized to visit this page")
    expect(page).to have_css("#homepage")
  end

  scenario "As a user I can create a proposed wager" do
    register_and_create_a_wager
    # expect(page).to have_content("You're proposed wager has been sent to Alex")
    expect(page.find("#proposed_wagers_table")).to have_content("Ping Pong Match")
    expect(page.find("#proposed_wagers_table")).to have_content(100)
    expect(page.find("#proposed_wagers_table")).not_to have_content(10000)
    expect(page.find("#wagers")).to have_content(100)
    expect(page.find("#net_amount")).to have_content(300)
  end

  scenario "As a user I can see a proposed wager in which I'm the wageree" do
    register_and_create_a_wager
    click_on "Logout"

    login_a_registered_user("Alexander")
    expect(page.find("#proposed_wagers_table")).to have_content("Ping Pong Match")
    expect(page.find("#proposed_wagers_table")).to have_content(100)
    expect(page.find("#proposed_wagers_table")).not_to have_content(10000)
    expect(page.find("#proposed_wagers_table")).to have_content("Alexander")
  end

end
