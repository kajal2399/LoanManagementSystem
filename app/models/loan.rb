class Loan < ApplicationRecord
  belongs_to :user

  enum state: { requested: 0, approved: 1, open: 2, closed: 3, rejected: 4 }

  after_initialize :set_default_state, if: :new_record?


  def calculate_total_loan_amount
    interest_amount = amount * (interest_rate / 100 / (365 * 24 * 60 / 5))
    total_loan_amount = amount + interest_amount
    return total_loan_amount
  end


  private

  def set_default_state
    self.state ||= :requested
  end
end
