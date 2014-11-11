describe VideopagesController do

  let(:user) { FactoryGirl.create(:user) }
  let(:project) { FactoryGirl.create(:project, account_id: Account.last.id) }
  let(:videopage) { FactoryGirl.create(:videopage) }

  before :each do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    Project.any_instance.stub(:upload_embed).and_return(true)

    #doing auth
    sign_in user
    @request.host = "#{user.url}.stage.lvh.me"
  end

  context '#edit' do

    it "should create videopage" do
      get :edit, {id: project.cid}
      expect(project.videopage).to_not be nil
    end

    context 'when cid of project is correct' do
      it 'responds with 200' do
        get :edit, {id:project.cid}
        expect(response.status).to eq(200)
      end
    end

    context 'when cid of project is incorrect' do
      it 'responds with 404' do
        get :edit, {id:123}
        expect(response.status).to eq(404)
      end
    end

    it 'renders the edit template' do
      get :edit, {id:project.cid}
      expect(response).to render_template('edit')
    end


  end

  context '#show' do
    context 'when slug is not correct' do
      it 'responds with 404' do
        get :show, {id: 'bad_slug'}
        expect(response.status).to eq(404)
      end
    end

    context 'when subdomain is not correct' do
      it 'responds with 404' do
        @request.host = "bad_domain.stage.lvh.me"
        get :show, {id: videopage.slug}
        expect(response.status).to eq(404)
      end
    end

    context 'when slug and subdomain are correct' do
      it 'responds with 200' do
        get :show, {id: videopage.slug}
        expect(response.status).to eq(200)
      end
    end

    it 'renders the show template' do
      get :show, {id:videopage.slug}
      expect(response).to render_template('show')
    end

  end
end