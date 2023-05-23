require "application_system_test_case"

class CadenasTest < ApplicationSystemTestCase
  setup do
    @cadena = cadenas(:one)
  end

  test "visiting the index" do
    visit cadenas_url
    assert_selector "h1", text: "Cadenas"
  end

  test "should create cadena" do
    visit cadenas_url
    click_on "New cadena"

    fill_in "Balance", with: @cadena.balance
    fill_in "End date", with: @cadena.end_date
    fill_in "Installments", with: @cadena.installments
    fill_in "Intallment value", with: @cadena.installment_value
    fill_in "Name", with: @cadena.name
    fill_in "Periodicity", with: @cadena.periodicity
    fill_in "Start date", with: @cadena.start_date
    fill_in "Status", with: @cadena.status
    fill_in "Total participants", with: @cadena.total_participants
    click_on "Create Cadena"

    assert_text "Cadena was successfully created"
    click_on "Back"
  end

  test "should update Cadena" do
    visit cadena_url(@cadena)
    click_on "Edit this cadena", match: :first

    fill_in "Balance", with: @cadena.balance
    fill_in "End date", with: @cadena.end_date
    fill_in "Installments", with: @cadena.installments
    fill_in "Intallment value", with: @cadena.installment_value
    fill_in "Name", with: @cadena.name
    fill_in "Periodicity", with: @cadena.periodicity
    fill_in "Start date", with: @cadena.start_date
    fill_in "Status", with: @cadena.status
    fill_in "Total participants", with: @cadena.total_participants
    click_on "Update Cadena"

    assert_text "Cadena was successfully updated"
    click_on "Back"
  end

  test "should destroy Cadena" do
    visit cadena_url(@cadena)
    click_on "Destroy this cadena", match: :first

    assert_text "Cadena was successfully destroyed"
  end
end
