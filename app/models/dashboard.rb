class Dashboard


  def list_unallocated_chips(kenny_loggins)

    kenny_loggins.chips.where(status: "available")
  end

  def list_distributed_chips(kenny_loggins)
  kenny_loggins.chips.where(status: "distributed")
  end

end