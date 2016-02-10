require 'spec_helper'
describe Api::AccountController do
  
  it 'can get top_sell' do

  end
end
describe "let" do
  other_count = 0
  invocation_order = []

  let(:count) do
    invocation_order << :let!
    other_count += 1
  end

  it "calls the helper method in a before hook" do
    # count
    # invocation_order << :example
    # expect(invocation_order).to eq([:let!,:example])

    invocation_order << :example
    expect(invocation_order).to eq([:example])
    expect(other_count).to      eq(0)
    other_count +=1
    expect(other_count).to      eq(1)

  end
  it "calls the helper method in a before hook again" do
  # count
  # invocation_order << :example
  # expect(invocation_order).to eq([:let!,:example])  

  invocation_order << :example
  expect(invocation_order).to eq([:example,:example])
  expect(other_count).to      eq(1)
  other_count +=1
  expect(other_count).to      eq(2)

end
end