feature "visitor login" do

  before(:each) do
    visit "/"
  end

  scenario "non-registered visitor tries to login or visitor logs in w/ incorrect credentials" do
    fill_in "Username", with: "stephen"
    fill_in "Password", with: "123"
    click_on "Login"
    expect(page).to have_button("Login")
    expect(page).to have_content("The credentials you entered are incorrect.  Please try again.")
    expect(page).not_to have_button("Logout")
    expect(page).to have_link("Sign Up")
    expect(page).not_to have_link("Edit Profile")
  end

  context "User has regsitered" do
    before(:each) do
      create_user("Stephen")
      visit "/"
    end

    scenario "user can log in using their username" do
      login_user("Stephen")
      click_on "Dashboard"
      expect(page).to have_css("#show_dashboards")
    end

    scenario "user can log in using their email" do
      fill_in "Username", with: "stephen@gmail.com"
      fill_in "Password", with: "password"
      click_on "Login"
      expect(page).to have_css("#show_dashboards")
    end

  end

end

