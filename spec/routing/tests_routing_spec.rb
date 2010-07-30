require "spec_helper"

describe TestsController do
  describe "routing" do

        it "recognizes and generates #index" do
      { :get => "/tests" }.should route_to(:controller => "tests", :action => "index")
    end

        it "recognizes and generates #new" do
      { :get => "/tests/new" }.should route_to(:controller => "tests", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/tests/1" }.should route_to(:controller => "tests", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/tests/1/edit" }.should route_to(:controller => "tests", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/tests" }.should route_to(:controller => "tests", :action => "create")
    end

    it "recognizes and generates #update" do
      { :put => "/tests/1" }.should route_to(:controller => "tests", :action => "update", :id => "1")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/tests/1" }.should route_to(:controller => "tests", :action => "destroy", :id => "1")
    end

  end
end
