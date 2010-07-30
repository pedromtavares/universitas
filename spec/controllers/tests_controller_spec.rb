require 'spec_helper'

describe TestsController do

  def mock_test(stubs={})
    @mock_test ||= mock_model(Test, stubs).as_null_object
  end

  describe "GET index" do
    it "assigns all tests as @tests" do
      Test.stub(:all) { [mock_test] }
      get :index
      assigns(:tests).should eq([mock_test])
    end
  end

  describe "GET show" do
    it "assigns the requested test as @test" do
      Test.stub(:find).with("37") { mock_test }
      get :show, :id => "37"
      assigns(:test).should be(mock_test)
    end
  end

  describe "GET new" do
    it "assigns a new test as @test" do
      Test.stub(:new) { mock_test }
      get :new
      assigns(:test).should be(mock_test)
    end
  end

  describe "GET edit" do
    it "assigns the requested test as @test" do
      Test.stub(:find).with("37") { mock_test }
      get :edit, :id => "37"
      assigns(:test).should be(mock_test)
    end
  end

  describe "POST create" do

    describe "with valid params" do
      it "assigns a newly created test as @test" do
        Test.stub(:new).with({'these' => 'params'}) { mock_test(:save => true) }
        post :create, :test => {'these' => 'params'}
        assigns(:test).should be(mock_test)
      end

      it "redirects to the created test" do
        Test.stub(:new) { mock_test(:save => true) }
        post :create, :test => {}
        response.should redirect_to(test_url(mock_test))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved test as @test" do
        Test.stub(:new).with({'these' => 'params'}) { mock_test(:save => false) }
        post :create, :test => {'these' => 'params'}
        assigns(:test).should be(mock_test)
      end

      it "re-renders the 'new' template" do
        Test.stub(:new) { mock_test(:save => false) }
        post :create, :test => {}
        response.should render_template("new")
      end
    end

  end

  describe "PUT update" do

    describe "with valid params" do
      it "updates the requested test" do
        Test.should_receive(:find).with("37") { mock_test }
        mock_test.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :test => {'these' => 'params'}
      end

      it "assigns the requested test as @test" do
        Test.stub(:find) { mock_test(:update_attributes => true) }
        put :update, :id => "1"
        assigns(:test).should be(mock_test)
      end

      it "redirects to the test" do
        Test.stub(:find) { mock_test(:update_attributes => true) }
        put :update, :id => "1"
        response.should redirect_to(test_url(mock_test))
      end
    end

    describe "with invalid params" do
      it "assigns the test as @test" do
        Test.stub(:find) { mock_test(:update_attributes => false) }
        put :update, :id => "1"
        assigns(:test).should be(mock_test)
      end

      it "re-renders the 'edit' template" do
        Test.stub(:find) { mock_test(:update_attributes => false) }
        put :update, :id => "1"
        response.should render_template("edit")
      end
    end

  end

  describe "DELETE destroy" do
    it "destroys the requested test" do
      Test.should_receive(:find).with("37") { mock_test }
      mock_test.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the tests list" do
      Test.stub(:find) { mock_test }
      delete :destroy, :id => "1"
      response.should redirect_to(tests_url)
    end
  end

end
