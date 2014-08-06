
feature "view mvps"  do

  scenario "visitor clicks on the mvp link to see the minimum viable products" do
    visit "/"
    click_on "MVPs"

    expect(page).to have_css("#index_mvps")
    expect(page).not_to have_link("Add New")
  end

  scenario "visitor visits mvp view and wants to return to home" do
    visit "/"
    click_on "MVPs"
    click_on "Back to Home"

    expect(page).to have_css "#homepage"
  end
end