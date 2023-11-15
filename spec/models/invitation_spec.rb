require 'rails_helper'

RSpec.describe Invitation, type: :model do
  it "is valid with valid attributes" do
    cadena = create(:cadena)
    invitation = create(:invitation, cadena: cadena, sender: cadena.admin)
    expect(invitation).to be_valid
  end
  it "is not valid without a phone number"
  it "is not valid without a cadena"
  it "is not valid without an email"
  it "is not valid without a first name"
  it "is not valid without a last name"
end
