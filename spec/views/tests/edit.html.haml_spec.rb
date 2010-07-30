require 'spec_helper'

describe "tests/edit.html.haml" do
  before(:each) do
    @test = assign(:test, stub_model(Test,
      :new_record? => false,
      :oi => "MyString"
    ))
  end

  it "renders the edit test form" do
    render

    rendered.should have_selector("form", :action => test_path(@test), :method => "post") do |form|
      form.should have_selector("input#test_oi", :name => "test[oi]")
    end
  end
end
