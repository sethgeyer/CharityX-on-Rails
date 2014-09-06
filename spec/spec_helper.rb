


# This file was generated by the `rails generate rspec:install` command. Conventionally, all
# specs live under a `spec` directory, which RSpec adds to the `$LOAD_PATH`.
# The generated `.rspec` file contains `--require spec_helper` which will cause this
# file to always be loaded, without a need to explicitly require it in any files.
#
# Given that it is always loaded, you are encouraged to keep this file as
# light-weight as possible. Requiring heavyweight dependencies from this file
# will add to the boot time of your test suite on EVERY test run, even for an
# individual file that may not need all of that loaded. Instead, make a
# separate helper file that requires this one and then use it only in the specs
# that actually need it.
#
# The `.rspec` file also contains a few flags that are not defaults but that
# users commonly want.
#
# See http://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration
RSpec.configure do |config|
# The settings below are suggested to provide a good initial experience
# with RSpec, but feel free to customize to your heart's content.
=begin
  # These two settings work together to allow you to limit a spec run
  # to individual examples or groups you care about by tagging them with
  # `:focus` metadata. When nothing is tagged with `:focus`, all examples
  # get run.
  config.filter_run :focus
  config.run_all_when_everything_filtered = true

  # Many RSpec users commonly either run the entire suite or an individual
  # file, and it's useful to allow more verbose output when running an
  # individual spec file.
  if config.files_to_run.one?
    # Use the documentation formatter for detailed output,
    # unless a formatter has already been configured
    # (e.g. via a command-line flag).
    config.default_formatter = 'doc'
  end

  # Print the 10 slowest examples and example groups at the
  # end of the spec run, to help surface which specs are running
  # particularly slow.
  config.profile_examples = 10

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = :random

  # Seed global randomization in this process using the `--seed` CLI option.
  # Setting this allows you to use `--seed` to deterministically reproduce
  # test failures related to randomization by passing the same `--seed` value
  # as the one that triggered the failure.
  Kernel.srand config.seed

  # rspec-expectations config goes here. You can use an alternate
  # assertion/expectation library such as wrong or the stdlib/minitest
  # assertions if you prefer.
  config.expect_with :rspec do |expectations|
    # Enable only the newer, non-monkey-patching expect syntax.
    # For more details, see:
    #   - http://myronmars.to/n/dev-blog/2012/06/rspecs-new-expectation-syntax
    expectations.syntax = :expect
  end

  # rspec-mocks config goes here. You can use an alternate test double
  # library (such as bogus or mocha) by changing the `mock_with` option here.
  config.mock_with :rspec do |mocks|
    # Enable only the newer, non-monkey-patching expect syntax.
    # For more details, see:
    #   - http://teaisaweso.me/blog/2013/05/27/rspecs-new-message-expectation-syntax/
    mocks.syntax = :expect

    # Prevents you from mocking or stubbing a method that does not exist on
    # a real object. This is generally recommended.
    mocks.verify_partial_doubles = true
  end
=end
end

def fill_in_registration_form(name)
  visit "/users/new"
  within(page.find(".registration")) {fill_in "First name", with: "Steve"}
  within(page.find(".registration")) {fill_in "Last name", with: "Ward"}
  within(page.find(".registration")) { fill_in "Username", with: "#{name.downcase}y" }
  within(page.find(".registration")) { fill_in "Email", with: "#{name.downcase}@gmail.com" }
  within(page.find(".registration")) { fill_in "Password", with: name.downcase }
  within(page.find(".registration")) { fill_in "Profile picture", with: "http://google.com" }
  within(page.find(".registration")) { click_on "Submit" }
end

def login_a_registered_user(name)
  fill_in "Username", with: "#{name.downcase}y"
  fill_in "Password", with: name.downcase
  click_on "Login"
end

def register_a_new_charity(charity_name)
  fill_in "Charity Name", with: charity_name
  fill_in "Federal Tax ID", with: 123456789
  fill_in "Primary POC", with: "Al Smith"
  fill_in "POC Email", with: "alsmith@gmail.com"
  click_on "Submit"
end

def fund_my_account_with_a_credit_card(deposit_amount)
  within(page.find("#fund-my-account")) {click_link "+"}
  fill_in "Amount", with: deposit_amount
  # fill_in "Credit Card Number", with: 123456789
  # fill_in "Exp Date", with: "2014-07-31"
  # fill_in "Name on Card", with: "Stephen Geyer"
  # within(page.find("#new_deposits")) { choose "Visa" }

  click_on "Submit"



end

def distribute_funds_from_my_account(distribution_amount, charity)
  within(page.find("#distribute-funds")) {click_link "+"}
  fill_in "Amount", with: distribution_amount
  select charity, from: "Charity"
  click_on "Submit"
end

def register_users_and_create_a_wager(wageree, wagerer)
  fill_in_registration_form(wageree)
  fund_my_account_with_a_credit_card(100)
  click_on "Logout"
  fill_in_registration_form(wagerer)
  fund_my_account_with_a_credit_card(40)
  #visit "/proposed_wagers/new"
  within(page.find("#wager-funds")) {click_link "+"}
  fill_in "wager_title", with: "Ping Pong Match between S & A"
  fill_in "wager_date_of_wager", with: "2017-07-31"
  fill_in "wager_details", with: "Game to 21, standard rules apply"
  fill_in "wager_amount", with: 10
  fill_in "With:", with: "alexandery"
  click_on "Submit"
end

def create_a_public_wager(potential_wageree1, potential_wageree2, wagerer)
  fill_in_registration_form(potential_wageree1)
  fund_my_account_with_a_credit_card(100)
  click_on "Logout"
  fill_in_registration_form(potential_wageree2)
  fund_my_account_with_a_credit_card(100)
  click_on "Logout"

  fill_in_registration_form(wagerer)
  fund_my_account_with_a_credit_card(40)

  within(page.find("#wager-funds")) {click_link "+"}
  fill_in "wager_title", with: "Public Ping Pong"
  fill_in "wager_date_of_wager", with: "2017-07-31"
  fill_in "wager_details", with: "Game to 21, standard rules apply"
  fill_in "wager_amount", with: 10
  fill_in "With:", with: ""
  click_on "Submit"
end

def user_creates_a_solicitation_wager(wagererTheUser, wagereeTheNonUser)
  fill_in_registration_form(wagererTheUser)
  fund_my_account_with_a_credit_card(100)
  within(page.find("#wager-funds")) {click_link "+"}
  fill_in "wager_title", with: "Ping Pong"
  fill_in "wager_date_of_wager", with: "2017-07-31"
  fill_in "wager_details", with: "Game to 21, standard rules apply"
  fill_in "wager_amount", with: 10
  fill_in "With:", with: "#{wagereeTheNonUser.downcase}@gmail.com"
  click_on "Submit"
end