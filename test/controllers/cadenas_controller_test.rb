require "test_helper"

class CadenasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @cadena = cadenas(:one)
  end

  test "should get index" do
    get cadenas_url
    assert_response :success
  end

  test "should get new" do
    get new_cadena_url
    assert_response :success
  end

  test "should create cadena" do
    assert_difference("Cadena.count") do
      post cadenas_url, params: { cadena: { balance: @cadena.balance, end_date: @cadena.end_date, installments: @cadena.installments, installment_value: @cadena.installment_value, name: @cadena.name, periodicity: @cadena.periodicity, start_date: @cadena.start_date, status: @cadena.status, desired_participants: @cadena.desired_participants } }
    end

    assert_redirected_to cadena_url(Cadena.last)
  end

  test "should show cadena" do
    get cadena_url(@cadena)
    assert_response :success
  end

  test "should get edit" do
    get edit_cadena_url(@cadena)
    assert_response :success
  end

  test "should update cadena" do
    patch cadena_url(@cadena), params: { cadena: { balance: @cadena.balance, end_date: @cadena.end_date, installments: @cadena.installments, installment_value: @cadena.installment_value, name: @cadena.name, periodicity: @cadena.periodicity, start_date: @cadena.start_date, status: @cadena.status, desired_participants: @cadena.desired_participants } }
    assert_redirected_to cadena_url(@cadena)
  end

  test "should destroy cadena" do
    assert_difference("Cadena.count", -1) do
      delete cadena_url(@cadena)
    end

    assert_redirected_to cadenas_url
  end
end
