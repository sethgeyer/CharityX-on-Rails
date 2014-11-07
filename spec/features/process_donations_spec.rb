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
    expect(page).to have_content(timezone_adjusted_datetime(@distribution.created_at, @admin ))
  end







end