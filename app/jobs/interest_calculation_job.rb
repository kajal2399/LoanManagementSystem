class InterestCalculationJob < ApplicationJob
  queue_as :default

  def perform
    Loan.where(state: 'open').find_each do |loan|
      interest_amount = loan.amount * (loan.interest_rate / 100 / (365 * 24 * 60 / 5))
      loan.amount += interest_amount
      loan.save!
    end
  end
end
