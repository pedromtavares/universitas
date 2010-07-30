require 'spec_helper'

describe "tests/new.html.haml" do
  before(:each) do
    assign(:test, stub_model(Test,
      :new_record? => true,
      :oi => "MyString"
    ))
  end

  it "renders new test form" do
    render

    rendered.should have_selector("form", :action => tests_path, :method => "post") do |form|
      form.should have_selector("input#test_oi", :name => "test[oi]")
    end
  end
end
