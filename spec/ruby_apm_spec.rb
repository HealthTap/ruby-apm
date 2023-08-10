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
      let(:env) { 'test' }
      let(:env_overrides) { {} }
      let(:root_overrides) { { license_key: '12345' } }
      let(:overrides) do
        {
          **root_overrides,
          env => env_overrides
        }.with_indifferent_access
      end
      let(:expected_config) { root_overrides }

      shared_examples 'configured agent' do
        before do
          ENV['NEW_RELIC_ENV'] = env
          subject
        end

        it 'returns the correct overrides' do
          expect(described_class.config.agent).to eql(:newrelic)
          expect(described_class.config.newrelic).to eql(overrides)
          expect(NewRelic::Agent.config[:app_name].first).to eql("#{app_name} (#{env.capitalize})")

          expected_config.each do |key, value|
            expect(NewRelic::Agent.config[key]).to eql(value)
          end
        end
      end

      it_behaves_like 'configured agent'

      context 'with environment overrides' do
        let(:env_overrides) { { license_key: '00000' } }

        context 'when override matches current environment' do
          let(:expected_config) { root_overrides.deep_merge(env_overrides) }

          it_behaves_like 'configured agent'
        end

        context 'when override does not match current environment' do
          let(:overrides) do
            {
              **root_overrides,
              'not_current_env' => env_overrides
            }.with_indifferent_access
          end

          it_behaves_like 'configured agent'
        end
      end
    end
  end
end
