require "rails_helper"

describe AccountService do
  include ErrorExamples

  describe "#initialize" do
    context "initialize with no option." do
      it "has origin strategy" do
        result = described_class.new
        expect(result.instance_variable_get(:@strategy)).to be_a ::AccountStrategies::Origin
      end
    end
    context "initialize with option." do
      it "has other strategy" do
        result = described_class.new(strategy: ::AccountStrategies::ThirdParty.new)
        expect(result.instance_variable_get(:@strategy)).to be_a ::AccountStrategies::ThirdParty
      end
    end
  end

  describe "#create" do
    let!(:params) { ActionController::Parameters.new({}) }
    let!(:option) { {} }

    it "call strategy's create method" do
      strategy = AccountStrategies::Origin.new
      expect(strategy).to receive(:create).with(params, option)
      described_class.new(strategy: strategy).create(params, option)
    end
  end

  describe "#authenticate" do
    let!(:params) { ActionController::Parameters.new({}) }

    it "call strategy's authenticate method" do
      strategy = AccountStrategies::Origin.new
      expect(strategy).to receive(:authenticate).with(params)
      described_class.new(strategy: strategy).authenticate(params)
    end
  end

  describe "#confirm_email" do
    subject { AccountService.new.confirm_email(token) }
    let!(:user) { create :user, skip_confirm: false }
    let!(:token) { user.confirmation_token }

    before { Timecop.freeze(Time.local(2016, 1, 1)) }

    context "user found by token" do
      it "calls confirm! of user" do
        expect(User).to receive(:find_by_confirmation_token).with(user.confirmation_token).and_return(user)
        expect(user).to receive(:confirm!)
        subject
      end

      it "updates confirmed_at" do
        result = subject
        expect(result.confirmed_at).to eq Time.zone.now
      end
    end
    context "user not found by token" do
      let!(:token) { user.confirmation_token + "a" }
      it_behaves_like "bad request error", :resource_not_found, :token
    end
  end

  describe "#update_email" do
    subject { AccountService.new.update_email(params) }
    let!(:params) { ActionController::Parameters.new(attrs) }
    let!(:user) { create :user,
                  skip_confirm: true,
                  email: email,
                  name: name,
                  password: password,
                  password_confirmation: password
    }
    let!(:email) { "test@test.test.com" }
    let!(:name) { "testee" }
    let!(:password) { "Abcd1234/" }
    let!(:attrs) do
      {
        id: user.id,
        name: name,
        email: email + "a",
        password: password
      }
    end
    context "specified params is correct" do
      it "updates user unconfirmed_email" do
        result = subject
        expect(result.email).to eq email
        expect(result.unconfirmed_email).to eq(email + "a")
      end
    end
    context "user is not found by id" do
      before { params[:id] = -1 }
      it_behaves_like "bad request error", :resource_not_found, :id
    end
  end

  describe "#update_name" do
    subject { AccountService.new.update_name(params) }
    let!(:params) { ActionController::Parameters.new(attrs) }
    let!(:user) { create :user,
                  skip_confirm: true,
                  email: email,
                  name: name,
                  password: password,
                  password_confirmation: password
    }
    let!(:email) { "test@test.test.com" }
    let!(:name) { "testee" }
    let!(:password) { "Abcd1234/" }
    let!(:attrs) do
      {
        id: user.id,
        name: name,
        password: password
      }
    end
    context "specified params is correct" do
      it "updates user name" do
        params[:name] = name + "a"
        result = subject
        expect(result.name).to eq(name + "a")
      end
    end
    context "user is not found by id" do
      before { params[:id] = -1 }
      it_behaves_like "bad request error", :resource_not_found, :id
    end
    context "specified password is not correct" do
      before { params[:password] = password + "a" }
      it_behaves_like "bad request error", :incorrect, :password
    end
  end

  describe "#update_password" do
    subject { AccountService.new.update_password(params) }
    let!(:params) { ActionController::Parameters.new(attrs) }
    let!(:user) { create :user,
                  skip_confirm: true,
                  email: email,
                  name: name,
                  password: password,
                  password_confirmation: password
    }
    let!(:email) { "test@test.test.com" }
    let!(:name) { "testee" }
    let!(:password) { "Abcd1234/" }
    let!(:attrs) do
      {
        id: user.id,
        name: name,
        old_password: password,
        password: password + "a",
        password_confirmation: password + "a"
      }
    end
    context "specified params is correct" do
      it "updates user password" do
        params[:password] = password + "a"
        params[:password_confirmation] = params[:password]
        result = subject
        expect(result.password).to eq(password + "a")
      end
    end
    context "user is not found by id" do
      before { params[:id] = -1 }
      it_behaves_like "bad request error", :resource_not_found, :id
    end
    context "specified old password is not correct" do
      before { params[:old_password] = password + "b" }
      it_behaves_like "bad request error", :incorrect, :old_password
    end
  end

  describe "#reset_password" do
    subject { AccountService.new.reset_password(params) }
    let!(:params) { ActionController::Parameters.new(attrs) }
    let!(:user) { create :user,
                  skip_confirm: true,
                  email: email,
                  name: name,
                  password: password,
                  password_confirmation: password,
                  reset_password_token: "token",
                  reset_password_sent_at: Time.zone.now
    }
    let!(:email) { "test@test.test.com" }
    let!(:name) { "testee" }
    let!(:password) { "Abcd1234/" }
    let!(:attrs) do
      {
        token: user.reset_password_token,
        password: password + "a",
        password_confirmation: password + "a"
      }
    end

    context "user found by token" do
      it "updates password" do
        user = subject
        expect(user.password).to eq(password + "a")
      end
      it "calls reset_password! of user" do
        expect(User).to receive(:find_by_reset_password_token).with(attrs[:token]).and_return(user)
        expect(user).to receive(:reset_password!).with(attrs[:password], attrs[:password_confirmation])
        subject
      end
    end
    context "user not found by token" do
      before { params[:token] = user.reset_password_token + "a" }
      it_behaves_like "bad request error", :resource_not_found, :token
    end
  end

  describe "#issue_reset_password_token" do
    subject { AccountService.new.issue_reset_password_token(params) }
    let!(:params) { ActionController::Parameters.new(attrs) }
    let!(:user) { create :user,
                  skip_confirm: true,
                  email: email,
                  reset_password_token: nil,
                  reset_password_sent_at: nil
    }
    let!(:email) { "test@test.test.com" }
    let!(:attrs) do
      {
        email: email
      }
    end
    context "user found by email" do
      it "reset_password_sent_at and reset_password_token" do
        user = subject
        expect(user.reset_password_token).to be_present
        expect(user.reset_password_sent_at).to be_present
      end
      it "calls issue_reset_password_token! of user" do
        expect(User).to receive(:find_by_email).with(attrs[:email]).and_return(user)
        expect(user).to receive(:issue_reset_password_token!)
        subject
      end
    end
    context "not exists email" do
      before { params[:email] = user.email + "a" }
      it_behaves_like "bad request error", :not_exists, :email
    end
  end

  describe "#delete" do
    subject { AccountService.new.delete(params) }
    let!(:params) { ActionController::Parameters.new(attrs) }
    let!(:user) { create :user,
                  skip_confirm: true,
                  password: password,
                  password_confirmation: password
    }
    let!(:password) { "Abcd1234/" }
    let!(:attrs) do
      {
        id: user.id,
        password: password
      }
    end
    context "specified params is correct" do
      it "deletes user name" do
        expect { subject }.to change(User, :count).by(-1)
      end
    end
    context "user is not found by id" do
      before { params[:id] = -1 }
      it_behaves_like "bad request error", :resource_not_found, :id
    end
    context "specified password is not correct" do
      before { params[:password] = password + "a" }
      it_behaves_like "bad request error", :incorrect, :password
    end
  end

  describe "#resend_confirmation_notification" do
    subject { AccountService.new.resend_confirmation_notification(id) }

    context "when user not found" do
      let!(:id) { nil }
      it_behaves_like "bad request error", :resource_not_found, :id
    end

    context "when user already confirmed" do
      let!(:user) { create :user, skip_confirm: true }
      let!(:id) { user.id }
      it_behaves_like "bad request error", :already_confirmed, :email
    end

    context "when user not confirmed yet" do
      let!(:user) { create :user, skip_confirm: false }
      let!(:id) { user.id }
      it "resend confirmation notification" do
        expect(User).to receive(:find_by_id).and_return(user)
        expect(user).to receive(:resend_confirmation_notification!)
        subject
      end
    end
  end
end
