# frozen_string_literal: true

require 'spec_helper'

RSpec.describe TableTopBot::HelloWorld do
  let(:hello_world) { described_class.new }

  describe '.hello' do
    it 'returns hello world' do
      expect(hello_world.hello).to eq 'Hello World'
    end
  end
end
