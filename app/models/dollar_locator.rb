class DollarLocator


  def initialize(kenny_loggins)
    @kenny_loggins = kenny_loggins
  end

  def find_deposits
    @kenny_loggins.deposits.sum(:amount) / 100
  end


end