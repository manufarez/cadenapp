require 'rails_helper'

RSpec.describe Cadena, type: :model do
  it 'should have an identical number of desired_installments and desired_participants' do
    cadena = build(:cadena, desired_installments: 10, desired_participants: 11)
    expect(cadena.valid?).to be false
  end

  it 'should have a saving goal equal to the installment value over the number of months' do
    cadena = build(:cadena, saving_goal: -100_000)
    expect(cadena.valid?).to be false
  end

  it 'should throw an error if end_date does not match number of installments' do
    cadena = build(:cadena, end_date: Date.yesterday)
    expect(cadena.valid?).to be false
  end

  it 'should not have a start_date equal or inferior to the creation date' do
    cadena = build(:cadena, start_date: Time.zone.today)
    expect(cadena.valid?).to be false
  end

  it 'should have an admin' do
    cadena = build(:cadena)
    # no admin, should be false
    expect(cadena.valid?).to be false
  end

  context 'when the periodicity is "monthly"' do
    it 'ends in the same number of months' do
      cadena = create(:cadena, periodicity: 'monthly')
      expect(cadena.end_date).to(eq(cadena.start_date + cadena.desired_installments.months))
    end
  end

  context 'when the periodicity is "bimonthly"' do
    it 'ends twice as fast' do
      cadena = create(:cadena, periodicity: 'bimonthly')
      expect(cadena.end_date).to(eq(cadena.start_date + (cadena.desired_installments / 2).months))
    end
  end
end
