describe MakeMeSpiffy::InputManifest do
  describe 'concourse.yml' do
    let(:fixture) { fixture_path("concourse.yml") }
    subject { MakeMeSpiffy::InputManifest.from_file(fixture) }

    describe ".name" do
      it { expect(subject.manifest["name"]).to eq "concourse" }
      describe "spiffy" do
        before do
          @value = subject.spiffy("name", "meta.name")
        end
        it {expect(subject.manifest["name"]).to eq "(( meta.name ))"}
        it {expect(subject.manifest["meta"]).to eq({"name" => "concourse"}) }
        it {expect(@value).to eq "concourse"}
      end
    end
  end
end
