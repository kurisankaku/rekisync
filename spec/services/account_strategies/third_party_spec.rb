require "rails_helper"

describe AccountStrategies::ThirdParty do
  describe "#create" do
    subject { described_class.new.create(params, option) }
    let!(:params) { ActionController::Parameters.new(attrs) }
    let!(:option) do
      {
        auth_hash: {
          provider: "twitter",
          uid: uid,
          credentials: { token: "token" }
        }
      }
    end
    let!(:uid) { "1234" }
    let!(:email) { "test@test.test.com" }
    let!(:name) { "testee" }
    let!(:attrs) do
      { name: name,
        email: email }
    end

    context "not found exist token" do
      it "creates new user and new third party access tokens" do
        expect { subject }.to change(User, :count).by(1).and change(ThirdPartyAccessToken, :count).by(1)
      end

      context "when confirmation skip" do
        before { option[:skip_confirmation] = true }
        it "filled confirmed_at" do
          user = subject
          expect(user.confirmed_at).to be_present
        end
      end
    end

    context "found exist token" do
      let!(:access_token) { create :third_party_access_token, uid: uid, user: user, provider: "twitter" }
      let!(:user) { create :user }
      before { option[:auth_hash][:credentials][:token] = "update_token" }

      it "not increase access token and user count" do
        expect { subject }.to change(User, :count).by(0).and change(ThirdPartyAccessToken, :count).by(0)
      end

      it "updates access token and user attributes" do
        user = subject
        expect(user.name).to eq name
        expect(user.unconfirmed_email).to eq email
        expect(user.third_party_access_tokens.first.token).to eq "update_token"
      end
    end
  end

  describe "#authenticate" do
    subject { described_class.new.authenticate(params) }
    let!(:params) { ActionController::Parameters.new(attrs) }
    let!(:attrs) do
      {
        auth_hash: {
          provider: "twitter",
          uid: uid,
          credentials: { token: "token" }
        }
      }
    end
    let!(:uid) { "1234" }

    context "not found exist token" do
      it "is nil" do
        expect(subject).to be_nil
      end
    end

    context "found exist token" do
      let!(:access_token) { create :third_party_access_token, uid: uid, user: user, provider: "twitter" }
      let!(:user) do
        create :user,
               last_sign_in_at: Time.local(2015, 12, 30),
               current_sign_in_at: Time.local(2015, 12, 31),
               failed_attempts: 3,
               locked_at: Time.local(2015, 12, 31)
      end
      before do
        params[:auth_hash][:credentials][:token] = "update_token"
        Timecop.freeze(Time.local(2016, 1, 1))
      end

      it "updates access token and user attributes" do
        user = subject
        expect(user.last_sign_in_at).to eq Time.local(2015, 12, 31)
        expect(user.current_sign_in_at).to eq Time.local(2016, 1, 1)
        expect(user.failed_attempts).to eq 0
        expect(user.locked_at).to be_nil
        expect(user.third_party_access_tokens.first.token).to eq "update_token"
      end
    end
  end

  describe "#third_party_access_token_params" do
    subject { described_class.new.send(:third_party_access_token_params, params) }
    context "provider eq twitter" do
      let(:params) do
        {
          provider: "twitter",
          uid: "uid",
          credentials: { token: "token" }
        }
      end
      it "generate attributes of ThirdPartyAccessToken" do
        result = subject
        expect(result[:uid]).to eq "uid"
        expect(result[:provider]).to eq "twitter"
        expect(result[:token]).to eq "token"
      end
    end
    context "provider eq google_oauth2" do
      let(:params) do
        {
          provider: "google_oauth2",
          uid: "uid",
          credentials:
          {
            token: "token",
            refresh_token: "refresh_token",
            expires_at: "expires_at"
          }
        }
      end
      it "generate attributes of ThirdPartyAccessToken" do
        result = subject
        expect(result[:uid]).to eq "uid"
        expect(result[:provider]).to eq "google_oauth2"
        expect(result[:token]).to eq "token"
        expect(result[:refresh_token]).to eq "refresh_token"
        expect(result[:expires_in]).to eq "expires_at"
      end
    end
    context "provider eq facebook" do
      let(:params) do
        {
          provider: "facebook",
          uid: "uid",
          credentials:
          {
            token: "token",
            expires_at: "expires_at"
          }
        }
      end
      it "generate attributes of ThirdPartyAccessToken" do
        result = subject
        expect(result[:uid]).to eq "uid"
        expect(result[:provider]).to eq "facebook"
        expect(result[:token]).to eq "token"
        expect(result[:expires_in]).to eq "expires_at"
      end
    end
  end
end
