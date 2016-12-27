require "rails_helper"

describe AccountStrategies::Origin do
  include ErrorExamples

  describe "#create" do
    subject { described_class.new.create(params, option) }
    let!(:params) { ActionController::Parameters.new(attrs) }
    let!(:option) { {} }
    let!(:email) { "test@test.test.com" }
    let!(:name) { "test" }
    let!(:attrs) do
      { name: name,
        email: email,
        password: "Abcd1234/",
        password_confirmation: "Abcd1234/" }
    end

    context "user not existed" do
      it "creates new user" do
        expect { subject }.to change(User, :count).by(1)
      end

      it "empty confirmed_at" do
        user = subject
        expect(user.confirmed_at).to be_nil
      end

      context "skip confirmation" do
        before do
          option[:skip_confirmation] = true
        end
        it "creates new user" do
          expect { subject }.to change(User, :count).by(1)
        end

        it "filled confirmed_at" do
          user = subject
          expect(user.confirmed_at).to be_present
        end

        it "calls skip confirmation!" do
          user = build(:user)
          expect(User).to receive(:new).and_return(user)
          expect(user).to receive(:skip_confirmation!)
          subject
        end
      end
    end

    context "user who not confirmed yet exists" do
      context "when third party access tokens is related" do
        let!(:user) { create :user, name: name, skip_confirm: false }
        before do
          create(:third_party_access_token, user: user)
        end
        it "raises not unique error." do
          begin
            subject
            fail
          rescue ActiveRecord::RecordInvalid => e
            expect(e.record.errors.details[:name]).to include(error: :taken, value: name)
          end
        end
      end

      context "when third party access tokens is not related" do
        context "when user found by name" do
          let!(:user) { create :user, name: name, skip_confirm: false }
          it "updates exists user" do
            expect { subject }.to change(User, :count).by(0)
          end
        end

        context "when user found by email" do
          let!(:user) { create :user, email: email, skip_confirm: false }
          it "updates exists user" do
            expect { subject }.to change(User, :count).by(0)
          end
        end

        context "password of params is blank" do
          let!(:user) { create :user, email: email, skip_confirm: false }
          before { params[:password] = "" }
          it "raises password blank error." do
            begin
              subject
              fail
            rescue ActiveRecord::RecordInvalid => e
              expect(e.record.errors.details[:password]).to include(error: :blank)
            end
          end
        end
      end
    end
  end

  describe "#authenticate" do
    subject { described_class.new.authenticate(params) }
    let!(:params) { ActionController::Parameters.new(attrs) }
    let!(:user) { create :user,
                  skip_confirm: true,
                  email: email,
                  name: name,
                  password: password,
                  password_confirmation: password,
                  current_sign_in_at: current_sign_in_at,
                  last_sign_in_at: last_sign_in_at,
                  locked_at: locked_at,
                  failed_attempts: 4
    }
    let!(:email) { "test@test.test.com" }
    let!(:name) { "test" }
    let!(:password) { "Abcd1234/" }
    let!(:current_sign_in_at) { Time.local(2015, 12, 30) }
    let!(:last_sign_in_at) { Time.local(2015, 12, 29) }
    let!(:locked_at) { Time.local(2015, 12, 31) }
    let!(:attrs) do
      {
        account_name: email,
        password: password
      }
    end
    before { Timecop.freeze(Time.local(2016, 1, 1)) }

    context "authorizes account" do
      context "account found by email" do
        it "updates sign in at and failed attempts, locked at" do
          attrs[:account_name] = email
          user = subject
          expect(user.current_sign_in_at).to eq Time.zone.now
          expect(user.last_sign_in_at).to eq current_sign_in_at
          expect(user.locked_at).to be_nil
          expect(user.failed_attempts).to eq 0
        end
      end
      context "account found by name" do
        it "updates sign in at and failed attempts, locked at" do
          attrs[:account_name] = name
          user = subject
          expect(user.current_sign_in_at).to eq Time.zone.now
          expect(user.last_sign_in_at).to eq current_sign_in_at
          expect(user.locked_at).to be_nil
          expect(user.failed_attempts).to eq 0
        end
      end
    end
    context "account not found" do
      before { params[:account_name] = name + "a" }
      it_behaves_like "bad request error", :invalid_account_name_or_password, :account_name
    end
    context "account is locked" do
      let!(:locked_at) { Time.now + 1.seconds }
      it_behaves_like "bad request error", :account_locked, :account_name
    end
    context "specified password is not correct" do
      before { params[:password] = password + "a" }
      it_behaves_like "bad request error", :invalid_account_name_or_password, :account_name
    end
  end
end
