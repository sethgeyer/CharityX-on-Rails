feature "Process Donations View" do

  before(:each) do
    @user = create_user_and_make_deposit("Stephen", 100)
    @distribution = create_a_distribution("Stephen", 10)
    @admin = create_admin("Administrator")
    visit "/"
    login_user("Administrator")
    visit donation_processors_path
  end

  scenario "expect Process donations page to show distrubtions" do
    expect(page).to have_content "User Distributions to Process"
    expect(page).to have_content "#{@user.first_name} #{@user.last_name}"
    expect(page).to have_content(@distribution.charity.name)
    expect(page).to have_content(timezone_adjusted_datetime(@distribution.created_at, @admin))
    expect(page).to have_content("$10")
    expect(page).not_to have_content("$1000")
    expect(page).to have_link("Cut Check")
    click_on "Cut Check"
    expect(page).to have_content("New Check")
    expect(page).to have_selector("input[value = 'Stephen Geyer']")
    expect(page).to have_selector("input[value='$10']")
    expect(page).to have_selector("input[value='#{@distribution.charity.name}']")

    fill_in "Check Number", with: "4987"
    click_on "Submit"
    expect(page).to have_content("User Distributions to Process")
    expect(page).to have_content("4987")
    expect(page).not_to have_content(Date.today)
  end







end