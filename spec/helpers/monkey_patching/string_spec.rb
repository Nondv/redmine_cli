require 'spec_helper'

RSpec.describe String do
  it 'can be cutted' do
    expect('hello'.cut(5)).to eq 'hello'
    expect('hello'.cut(3)).to eq '...'
    expect('hello world'.cut(8)).to eq 'hello...'
  end
end
