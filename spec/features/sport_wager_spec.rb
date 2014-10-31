feature "Create a sport wager" do
  before(:each) do
    create_user_and_make_deposit("Seth", 100)
    create_user_and_make_deposit("Alexander", 100)
    visit "/"
    login_user("Seth")
  end


  scenario "As a user, I can create a sport wager", js: true do
    within(page.find("#wager-funds")) { click_link "+" }
    expect(page).to have_button("Find a Game")
    click_on "Find a Game"
  end
end