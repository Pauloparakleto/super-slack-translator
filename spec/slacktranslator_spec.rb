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
      VCR.use_cassette("auth_test", erb: :true, record: :once) do
        expect(described_class.new.auth_test.fetch("ok")).to eq(true)
      end
    end
  end

  describe '#send_channel_message' do
    let(:channel) { '#social' }
    let(:message) { 'Eu sou apenas um rapaz latino americano' }

    it 'has ok true response' do
      VCR.use_cassette("send_channel_message", erb: :true, record: :once) do
        expect(described_class.new
          .send_channel_message(message, channel, :to_english).fetch("ok"))
          .to eq(true)
      end
    end
  end

  describe '#translate_message' do
    it 'translate message' do
      expect(described_class.new.translate_message('Olá Mundo')).to eq('Hello World')
    end
  end

  xit "does something useful" do
    expect(false).to eq(true)
  end
end
