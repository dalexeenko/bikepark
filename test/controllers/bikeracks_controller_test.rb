require 'test_helper'

class BikeracksControllerTest < ActionController::TestCase
  setup do
    @bikerack = bikeracks(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:bikeracks)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create bikerack" do
    assert_difference('Bikerack.count') do
      post :create, bikerack: { address: @bikerack.address, latitude: @bikerack.latitude, latlng: @bikerack.latlng, longitude: @bikerack.longitude, name: @bikerack.name, rack_id: @bikerack.rack_id }
    end

    assert_redirected_to bikerack_path(assigns(:bikerack))
  end

  test "should show bikerack" do
    get :show, id: @bikerack
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @bikerack
    assert_response :success
  end

  test "should update bikerack" do
    patch :update, id: @bikerack, bikerack: { address: @bikerack.address, latitude: @bikerack.latitude, latlng: @bikerack.latlng, longitude: @bikerack.longitude, name: @bikerack.name, rack_id: @bikerack.rack_id }
    assert_redirected_to bikerack_path(assigns(:bikerack))
  end

  test "should destroy bikerack" do
    assert_difference('Bikerack.count', -1) do
      delete :destroy, id: @bikerack
    end

    assert_redirected_to bikeracks_path
  end
end
