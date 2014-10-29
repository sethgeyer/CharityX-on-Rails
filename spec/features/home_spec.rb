feature "visitor visits homepage" do

  before(:each) do
    visit "/"
  end

  scenario "visitor can peruse the homepage" do
    expect(page).to have_button("Login")
    expect(page).to have_link("Sign Up")
    expect(page).not_to have_button("Logout")
    expect(page).not_to have_button("Edit Profile")
    expect(page).to have_link("Charities")
    expect(page).not_to have_link("Dashboard")
  end


  scenario "visitor wants to see charities via the link on the homepage" do
    click_on "Charities"
    expect(page).to have_css("#index_charities")
  end

  scenario "visitor wants to see the register page via the link on the homepage" do
    click_on "Sign Up"
    expect(page).to have_css("#new_users")
    expect(page).to have_link("Cancel")
  end

end