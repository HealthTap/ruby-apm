RSpec.describe RubyApm do
  it "has a version number" do
    expect(RubyApm::VERSION).not_to be nil
  end

  describe '.configure' do
    subject do
      described_class.configure do |config|
        config.app_name = app_name
        config.agent = agent
        config.send("#{agent}=", overrides)
      end
    end

    let(:app_name) { 'Test' }
    let(:agent) { nil }
    let(:overrides) { {} }

    context 'when agent is newrelic' do
      let(:agent) { :newrelic }
      let(:overrides) do
        {
          license_key: 'test'
        }
      end

      it 'works' do
        subject
        expect(described_class.config.agent).to eql(:newrelic)
        expect(described_class.config.newrelic).to eql(overrides)
        expect(NewRelic::Agent.config[:app_name].first).to eql("#{app_name} (development)")
      end
    end
  end
end
