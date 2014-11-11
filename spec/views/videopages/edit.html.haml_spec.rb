describe "videopages/edit.html.haml" do
  let(:project) { FactoryGirl.create :project }
  before :each do
    Project.any_instance.stub(:upload_embed).and_return(true)
  end
  context '#edit' do
    it "template was rendered" do
      assign(:project, project)
      render
      expect(rendered).to be
    end
  end
end