describe MakeMeSpiffy::OutputTemplateManifest do
  describe 'concourse.yml' do
    subject { MakeMeSpiffy::OutputTemplateManifest.from_file("tmp/new.yml") }

    it { expect(subject.manifest).to eq({}) }
    it {
      subject.insert_scope_value("meta.top.bottom", 123)
      expect(subject.manifest["meta"]).not_to be_nil
      expect(subject.manifest["meta"]["top"]).not_to be_nil
      expect(subject.manifest["meta"]["top"]["bottom"]).to eq(123)
    }
  end
end
