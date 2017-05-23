require "rails_helper"

describe TagService do
  include ErrorExamples

  describe "#create" do
    subject { described_class.new.create(name) }

    context "create a tag" do
      let!(:name) { "tag name" }
      it { expect { subject }.to change(Tag, :count).by(1) }
      it { expect(subject.name).to eq name }
    end

    context "create a tag with leading and trailing whitespace removed" do
      let!(:name) { " tag name " }
      it { expect(subject.name).to eq "tag name" }
    end
  end

  describe "#find_by_name" do
    subject { described_class.new.find_by_name(name, field) }

    context "find tag by specified name" do
      let!(:field) { :name }
      let!(:tag) { create :tag }
      let!(:name) { tag.name }

      it { expect(subject).to be_present }
    end

    context "not find tag by specified name" do
      let!(:field) { :name }
      let!(:tag) { create :tag }
      let!(:name) { tag.name + "1" }
      it_behaves_like "bad request error", :resource_not_found, :name
    end
  end

  describe "#search" do
    subject { described_class.new.search(params) }
    let!(:params) { ActionController::Parameters.new(attrs) }

    before do
      %w(test Atest testB CTestD 1test2 best).each do |item|
        Tag.create!(name: item)
      end
    end

    context "search targets by specified name and pagination." do
      let!(:attrs) do
        {
          name: "test",
          page: 2
        }
      end
      it { expect(subject.first.name).to eq "testB" }
      it { expect(subject.total_pages).to eq 3 }
      it { expect(subject.total_count).to eq 5 }
    end

    context "search without specifying words" do
      let!(:attrs) { {} }
      it { expect(subject.total_pages).to eq 3 }
      it { expect(subject.total_count).to eq 6 }
    end
  end
end
