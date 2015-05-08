describe MakeMeSpiffy::InputManifest do
  describe 'concourse.yml' do
    let(:fixture) { fixture_path("concourse.yml") }
    subject { MakeMeSpiffy::InputManifest.from_file(fixture) }

    describe "simple scope" do
      it { expect(subject.manifest["name"]).to eq "concourse" }
      describe "spiffy" do
        before do
          @value = subject.spiffy("name", "meta.name")
        end
        it {expect(subject.manifest["name"]).to eq "(( meta.name ))"}
        it {expect(@value).to eq "concourse"}
      end

      describe "insert_scope_value" do
        before do
          subject.insert_scope_value("meta.name", "(( merge ))")
        end
        it {expect(subject.manifest["meta"]).to_not be_nil }
        it {expect(subject.manifest["meta"]["name"]).to eq("(( merge ))") }
      end
    end

    describe "nested scope" do
      it { expect(subject.manifest["compilation"]["workers"]).to eq 3 }
      describe "spiffy" do
        before do
          @value = subject.spiffy("compilation.workers", "meta.instances.workers")
        end
        it {expect(subject.manifest["compilation"]["workers"]).to eq "(( meta.instances.workers ))"}
        it {expect(@value).to eq 3}
      end

      describe "insert_scope_value" do
        before do
          subject.insert_scope_value("meta.instances.workers", "(( merge ))")
        end
        it {expect(subject.manifest["meta"]).to_not be_nil }
        it {expect(subject.manifest["meta"]["instances"]).to_not be_nil }
        it {expect(subject.manifest["meta"]["instances"]["workers"]).to eq("(( merge ))") }
      end

      describe "bad input scope" do
        xit { expect(subject.manifest["compilation"]["foobar"]).to be_nil }
        xit { expect(subject.manifest["foobar"]["workers"]).to be_nil }
      end
    end

    describe "complex scope through named array" do
      it { expect(subject.manifest["jobs"][0]["name"]).to eq "web" }
      describe "spiffy" do
        before do
          @value = subject.spiffy("jobs.web.instances", "meta.instances.web")
        end
        it {expect(subject.manifest["jobs"][0]["name"]).to eq "web"}
        it {expect(subject.manifest["jobs"][0]["instances"]).to eq "(( meta.instances.web ))"}
        it {expect(subject.manifest["meta"["instances"]["web"]]).to eq("(( merge ))") }
        it {expect(@value).to eq 1}
      end
    end
  end
end
