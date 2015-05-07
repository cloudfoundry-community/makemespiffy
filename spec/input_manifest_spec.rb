describe MakeMeSpiffy::InputManifest do
  describe 'concourse.yml' do
    let(:fixture) { fixture_path("concourse.yml") }
    subject { MakeMeSpiffy::InputManifest.from_file(fixture) }
    it { expect(subject.manifest["name"]).to eq "concourse" }
  end
end
