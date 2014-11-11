describe Videopage do
  it "should create a new item" do
    saved_videopage = FactoryGirl.create(:videopage)
    searched_videopage = Videopage.find(saved_videopage.id)
    expect(searched_videopage.id).to eq(saved_videopage.id)
  end

  it "should save data" do
    videopage = FactoryGirl.create(:videopage)
    videopage.update_attributes(
      :template => {"class"=>"layout-1", "factor"=>"0", "bgheight"=>"0"},
      :widgets => '[{"id":1392817700158,"title":"test","class":"widget-title widget-content-null","font":"Arial","fontStyle":"normal","fontSize":"18","textColor":"#bbee00","backgroundColor":"","component":"title","dataCol":1,"dataRow":10,"dataSizex":12,"dataSizey":2,"validation":{"title":["required"]}},{"id":1392817711775,"text":"<p>\n\ttest\n</p>","class":"widget-paragraph","font":"Arial","fontStyle":"normal","fontSize":"12","textColor":"#ae8500","backgroundColor":"","component":"paragraph","dataCol":1,"dataRow":12,"dataSizex":6,"dataSizey":4,"validation":{"text":["required"]}}]',
      :seo => '{"keywords":null,"title":"","description":"","validation":{"title":["required"]}}',
      :settings => {"backgroundColor"=>"#0b6f00"},
      :slug => 'test'
    )
    expect(videopage.save).to be true
    expect(videopage.seo).to eq('{"keywords":null,"title":"","description":"","validation":{"title":["required"]}}')
  end
end