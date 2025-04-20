# frozen_string_literal: true

RSpec.describe Slack::Translator do
  it "has a version number" do
    expect(Slack::Translator::VERSION).not_to be nil
  end

  describe '#new' do
    it 'is thuthy' do
      expect(described_class.new).to be_truthy
    end
  end

  describe '#auth_test' do
    it 'is ok' do
      expect(described_class.new.auth_test.fetch("ok")).to eq(true)
    end
  end

  xit "does something useful" do
    expect(false).to eq(true)
  end
end
