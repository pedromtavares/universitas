require 'spec_helper'

describe "tests/new.html.erb" do
  before(:each) do
    assign(:test, stub_model(Test,
      :new_record? => true,
      :hi => "MyString"
    ))
  end

  it "renders new test form" do
    render

    rendered.should have_selector("form", :action => tests_path, :method => "post") do |form|
      form.should have_selector("input#test_hi", :name => "test[hi]")
    end
  end
end
