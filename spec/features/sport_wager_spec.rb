feature "Create a sport wager" do
  before(:each) do
    create_user_and_make_deposit("Stephen", 100)
    create_user_and_make_deposit("Alexander", 100)
    visit "/"
    login_user("Stephen")
  end


  # scenario "As a user, I can create a sport wager", js: true do
  #   within(page.find("#wager-funds")) { click_link "+" }
  #   expect(page).to have_button("Find a Game")
  #   fill_in "wager_amount", with: 50
  #   fill_in "With:", with: "alexander"
  #   click_on "Find a Game"
  #   sleep(3)
  #   click_on "Broncos"
  #   sleep(4)
  #   click_on "Submit"
  #
  #
  # end
end