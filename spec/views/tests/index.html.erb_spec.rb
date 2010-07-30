require 'spec_helper'

describe "tests/index.html.erb" do
  before(:each) do
    assign(:tests, [
      stub_model(Test,
        :hi => "Hi"
      ),
      stub_model(Test,
        :hi => "Hi"
      )
    ])
  end

  it "renders a list of tests" do
    render
    rendered.should have_selector("tr>td", :content => "Hi".to_s, :count => 2)
  end
end
