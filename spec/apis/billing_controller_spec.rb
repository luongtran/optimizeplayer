describe Api::V1::BillingController , :type => :api do

  # let!(:user) { FactoryGirl.create(:user) }

  before :each do
    # Project.any_instance.stub(:upload_embed).and_return(true)
    @ipn_query = {
      "cproditem" => "13",
      "ctranstime" => "1391583605",
      "ccustlastname" => "WALKER",
      "ccustcity" => "",
      "ccustaddr1" => "",
      "ccustaddr2" => "",
      "cbfpath" => "",
      "ctaxamount" => "0",
      "ctransrole" => "VENDOR",
      "ctransvendor" => "bizlaunch",
      "cvendthru" => "",
      "cshippingamount" => "0",
      "cbfid" => "",
      "cbf" => "",
      "ccustfullname" => "Johny Walker",
      "ctransreceipt" => "J3Z3EKKY",
      "ccustshippingstate" => "",
      "ccustcc" => "RU",
      "cprodtype" => "RECURRING",
      "cnoticeversion" => "4.0",
      "cprocessedpayments" => "1",
      "cverify" => "D2875DA3",
      "cnextpaymentdate" => "2014-03-04",
      "ccustshippingcountry" => "RU",
      "ctid" => "",
      "caccountamount" => "2670",
      "corderlanguage" => "EN",
      "ccuststate" => "",
      "ctransaction" => "TEST_SALE",
      "crebillamnt" => "112799",
      "ccustfirstname" => "JOHNY",
      "ccurrency" => "RUB",
      "ccustcounty" => "",
      "corderamount" => "112799",
      "cupsellreceipt" => "",
      "ctransaffiliate" => "",
      "crebillstatus" => "ACTIVE",
      "crebillfrequency" => "MONTHLY",
      "ccustemail" => "test@optimizeplayer.com",
      "ccustshippingzip" => "347922",
      "ccustzip" => "347922",
      "cfuturepayments" => "1",
      "ctranspaymentmethod" => "TEST",
      "cprodtitle" => "OptimizePlayer Basic Plan"
    }

    gateway = FactoryGirl.create(:gateway)
    transaction_mapping = FactoryGirl.create(:transaction_mapping)
  end

  context '#ipn' do
    it "making a request with data" do
      VCR.use_cassette('billing_ipn') do
        post "api/v1/billing/ipn/1", @ipn_query, :formate =>:json
      end
      expect(last_response.status).to eq(200)
    end
  end

end