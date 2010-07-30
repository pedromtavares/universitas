require 'spec_helper'

describe "tests/index.html.haml" do
  before(:each) do
    assign(:tests, [
      stub_model(Test,
        :oi => "Oi"
      ),
      stub_model(Test,
        :oi => "Oi"
      )
    ])
  end

  it "renders a list of tests" do
    render
    rendered.should have_selector("tr>td", :content => "Oi".to_s, :count => 2)
  end
end
