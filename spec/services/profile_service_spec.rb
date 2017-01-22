require "rails_helper"

describe ProfileService do
  include ErrorExamples

  describe "#create" do
    subject { described_class.new.create(user, params) }
    let!(:params) { ActionController::Parameters.new(attrs) }
    let!(:user) { create :user }
    let!(:name) { "name1" }
    let!(:about_me) { "about_me1" }
    let!(:avator_image) { Rack::Test::UploadedFile.new("spec/support/images/cat.jpg", "image/jpeg") }
    let!(:background_image) { Rack::Test::UploadedFile.new("spec/support/images/background.jpg", "image/jpeg") }
    let!(:birthday) { "1988-09-01" }
    let!(:country) { Country.find_by_code(:jp) }
    let!(:state_city) { Faker::Address.city }
    let!(:street) { Faker::Address.street_name }
    let!(:website) { Faker::Internet.url }
    let!(:google_plus) { Faker::Internet.url }
    let!(:facebook) { Faker::Internet.url }
    let!(:twitter) { Faker::Internet.url }
    let!(:attrs) do
      { name: name,
        about_me: about_me,
        avator_image: avator_image,
        background_image: background_image,
        birthday: birthday,
        country: { code: country.code },
        state_city: state_city,
        street: street,
        website: website,
        google_plus: google_plus,
        facebook: facebook,
        twitter: twitter }
    end

    it "creates new profile" do
      expect { subject }.to change(Profile, :count).by(1)
    end

    it "sets specified params" do
      result = subject
      expect(result.user).to eq user
      expect(result.name).to eq name
      expect(result.about_me).to eq about_me
      expect(result.avator_image).to be_present
      expect(result.background_image).to be_present
      expect(result.birthday).to eq Time.zone.local(1988, 9, 1)
      expect(result.birthday_access_scope).to eq AccessScope.find_by_code(:private)
      expect(result.country).to eq country
      expect(result.state_city).to eq state_city
      expect(result.street).to eq street
      expect(result.website).to eq website
      expect(result.google_plus).to eq google_plus
      expect(result.facebook).to eq facebook
      expect(result.twitter).to eq twitter
    end
  end

  describe "#update" do
    subject { described_class.new.update(id, params) }
    let!(:id) { profile.id }
    let!(:profile) do
      create :profile,
             name: "name",
             about_me: "about_me",
             avator_image: Rack::Test::UploadedFile.new("spec/support/images/cat.jpg", "image/jpeg"),
             background_image: Rack::Test::UploadedFile.new("spec/support/images/background.jpg", "image/jpeg"),
             country: Country.find_by_code(:ch),
             birthday: Time.zone.local(2016, 1, 1),
             birthday_access_scope: AccessScope.find_by_code(:private),
             state_city: Faker::Address.city,
             street: Faker::Address.street_name,
             website: Faker::Internet.url,
             google_plus: Faker::Internet.url,
             facebook: Faker::Internet.url,
             twitter: Faker::Internet.url
    end
    let!(:name) { "name1" }
    let!(:about_me) { "about_me1" }
    let!(:avator_image) { Rack::Test::UploadedFile.new("spec/support/images/background.jpg", "image/jpeg") }
    let!(:background_image) { Rack::Test::UploadedFile.new("spec/support/images/cat.jpg", "image/jpeg") }
    let!(:birthday) { "1988-09-01" }
    let!(:birthday_access_scope) { AccessScope.find_by_code(:public) }
    let!(:country) { Country.find_by_code(:jp) }
    let!(:state_city) { Faker::Address.city }
    let!(:street) { Faker::Address.street_name }
    let!(:website) { Faker::Internet.url }
    let!(:google_plus) { Faker::Internet.url }
    let!(:facebook) { Faker::Internet.url }
    let!(:twitter) { Faker::Internet.url }
    let!(:params) do
      ActionController::Parameters.new(
        name: name,
        about_me: about_me,
        avator_image: avator_image,
        background_image: background_image,
        birthday: birthday,
        birthday_access_scope: { code: birthday_access_scope.code },
        country: { code: country.code },
        state_city: state_city,
        street: street,
        website: website,
        google_plus: google_plus,
        facebook: facebook,
        twitter: twitter
      )
    end

    it "updates exists profile" do
      expect { subject }.to change(Profile, :count).by(0)
    end

    it "sets specified params" do
      result = subject
      expect(result.name).to eq name
      expect(result.about_me).to eq about_me
      expect(result.avator_image).to be_present
      expect(result.background_image).to be_present
      expect(result.birthday).to eq Time.zone.local(1988, 9, 1)
      expect(result.birthday_access_scope).to eq birthday_access_scope
      expect(result.country).to eq country
      expect(result.state_city).to eq state_city
      expect(result.street).to eq street
      expect(result.website).to eq website
      expect(result.google_plus).to eq google_plus
      expect(result.facebook).to eq facebook
      expect(result.twitter).to eq twitter
    end

    context "profile not found" do
      let!(:id) { nil }
      it_behaves_like "bad request error", :resource_not_found, :id
    end
  end
end
