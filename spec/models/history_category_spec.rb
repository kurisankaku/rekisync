require "rails_helper"

describe HistoryCategory do
  include ErrorExamples

  describe "#validate" do
    let(:model) { build :history_category }
    context "name" do
      it "is valid when its length is 1" do
        model.name = "a"
        expect(model).to be_valid
      end

      it "is valid when its length is 64" do
        model.name = "a" * 64
        expect(model).to be_valid
      end

      it "is invalid when its length is 65" do
        model.name = "a" * 65
        expect(model).to have(1).errors_on(:name)
      end

      it "is invalid when it is nil" do
        model.name = nil
        expect(model).to have(1).errors_on(:name)
      end

      it "is invalid when it is blank" do
        model.name = ""
        expect(model).to have(1).errors_on(:name)
      end

      context "when category type is large category" do
        context "when the name already exists" do
          before do
            create(:history_category, name: :test1)
          end
          it "is valid when name is not same." do
            model.name = "a"
            expect(model).to be_valid
          end
          it "is invalid when name is same." do
            model.name = :test1
            expect(model).to have(1).errors_on(:name)
          end
        end
      end

      context "when category type is middle category" do
        context "when the name of middle type already exists" do
          let!(:large_category1) { create :history_category, name: :test1 }
          let!(:large_category2) { create :history_category, name: :test2 }
          let!(:middle_category1) do
            create :history_category,
                   name: :m_test1,
                   large_category: large_category1
          end

          context "when large_category is same" do
            it "is valid when name is not same" do
              model.name = :test1
              model.large_category = large_category1
              expect(model).to be_valid
            end
            it "is invalid when name is same." do
              model.name = middle_category1.name
              model.large_category = large_category1
              expect(model).to have(1).errors_on(:name)
            end
          end
          context "when large_category is not same" do
            it "is valid when name is not same" do
              model.name = :test1
              model.large_category = large_category2
              expect(model).to be_valid
            end
            it "is valid when name is same." do
              model.name = middle_category1.name
              model.large_category = large_category2
              expect(model).to be_valid
            end
          end
        end
      end

      context "when category type is small category" do
        let!(:large_category1) { create :history_category, name: :test1 }
        let!(:large_category2) { create :history_category, name: :test2 }
        let!(:middle_category1) do
          create :history_category,
                 name: :m_test1,
                 large_category: large_category1
        end
        let!(:middle_category2) do
          create :history_category,
                 name: :m_test2,
                 large_category: large_category1
        end
        let!(:small_category1) do
          create :history_category,
                 name: :s_test1,
                 large_category: large_category1,
                 middle_category: middle_category1
        end

        context "when middle category is same" do
          it "is valid when name is not same" do
            model.name = :s_test2
            model.large_category = large_category1
            model.middle_category = middle_category1
            expect(model).to be_valid
          end
          it "is invalid when name is same." do
            model.name = small_category1.name
            model.large_category = large_category1
            model.middle_category = middle_category1
            expect(model).to have(1).errors_on(:name)
          end
        end

        context "when middle category is not same" do
          it "is valid when name is not same" do
            model.name = :s_test2
            model.large_category = large_category1
            model.middle_category = middle_category2
            expect(model).to be_valid
          end
          it "is invalid when name is same." do
            model.name = small_category1.name
            model.large_category = large_category1
            model.middle_category = middle_category2
            expect(model).to be_valid
          end
        end
      end
    end

    context "large_category" do
      let!(:large_category1) { create :history_category, name: :test1 }
      let!(:middle_category1) do
        create :history_category,
               name: :m_test1,
               large_category: large_category1
      end

      it "is invalid when large_category is nil, but middle_category is presented" do
        model.name = :s_test1
        model.large_category = nil
        model.middle_category = middle_category1
        expect(model).to have(1).errors_on(:large_category)
      end
    end

    context "middle_category" do
      let!(:large_category1) { create :history_category, name: :test1 }
      let!(:large_category2) { create :history_category, name: :test2 }
      let!(:middle_category1) do
        create :history_category,
               name: :m_test1,
               large_category: large_category1
      end
      it "is invalid when middle_category not belongs to large_category" do
        model.name = :s_test1
        model.large_category = large_category2
        model.middle_category = middle_category1
        expect(model).to have(1).errors_on(:middle_category)
      end
    end
  end

  describe "#middle_categories" do
    let!(:large_category1) { create :history_category, name: :test1 }
    let!(:large_category2) { create :history_category, name: :test2 }
    let!(:middle_category1) do
      create :history_category,
             name: :m_test1,
             large_category: large_category1
    end
    let!(:middle_category2) do
      create :history_category,
             name: :m_test22,
             large_category: large_category1
    end
    let!(:small_category1) do
      create :history_category,
             name: :s_test1,
             large_category: large_category1,
             middle_category: middle_category1
    end
    it { expect(large_category1.middle_categories.count).to  eq 2 }
    it { expect(middle_category1.middle_categories.count).to  eq 0 }
    it { expect(small_category1.middle_categories.count).to  eq 0 }
  end

  describe "#small_categories" do
    let!(:large_category1) { create :history_category, name: :test1 }
    let!(:large_category2) { create :history_category, name: :test2 }
    let!(:middle_category1) do
      create :history_category,
             name: :m_test1,
             large_category: large_category1
    end
    let!(:middle_category2) do
      create :history_category,
             name: :m_test22,
             large_category: large_category1
    end
    let!(:small_category1) do
      create :history_category,
             name: :s_test1,
             large_category: large_category1,
             middle_category: middle_category1
    end
    let!(:small_category2) do
      create :history_category,
             name: :s_test2,
             large_category: large_category1,
             middle_category: middle_category2
    end
    it { expect(large_category1.small_categories.count).to  eq 2 }
    it { expect(middle_category1.small_categories.count).to  eq 1 }
    it { expect(middle_category2.small_categories.count).to  eq 1 }
    it { expect(small_category1.small_categories.count).to  eq 0 }
  end

  describe "#large_category?" do
    let!(:large_category1) { create :history_category, name: :test1 }
    let!(:middle_category1) do
      create :history_category,
             name: :m_test1,
             large_category: large_category1
    end
    let!(:small_category1) do
      create :history_category,
             name: :s_test1,
             large_category: large_category1,
             middle_category: middle_category1
    end
    it { expect(large_category1.large_category?).to be true }
    it { expect(middle_category1.large_category?).to be false }
    it { expect(small_category1.large_category?).to be false }
  end

  describe "#middle_category?" do
    let!(:large_category1) { create :history_category, name: :test1 }
    let!(:middle_category1) do
      create :history_category,
             name: :m_test1,
             large_category: large_category1
    end
    let!(:small_category1) do
      create :history_category,
             name: :s_test1,
             large_category: large_category1,
             middle_category: middle_category1
    end
    it { expect(large_category1.middle_category?).to be false }
    it { expect(middle_category1.middle_category?).to be true }
    it { expect(small_category1.middle_category?).to be false }
  end
end
