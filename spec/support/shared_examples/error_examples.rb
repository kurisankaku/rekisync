module ErrorExamples
  shared_examples "bad request error" do |code, field|
    it "raise bad request erro code is #{code}, field is #{field}" do
      begin
        subject
        fail
      rescue BadRequestError => e
        expect(e.code).to eq (code)
        expect(e.field).to eq (field)
      end
    end
  end

  shared_examples "logical deletion" do |model_symbol|
    let!(:model) { create model_symbol }

    it "deletes by logical" do
      model.destroy
      clazz = Module.const_get(model_symbol.to_s.camelize)
      expect(clazz.count).to eq 0
      expect(clazz.with_deleted.count).to eq 1
    end
  end

  shared_examples "dependent destroy" do |model_symbol, dependents_model_symbol, dependent_model_factory_name|
    let!(:model) { create model_symbol }
    let!(:dependents_model_singular_name) { dependents_model_symbol.to_s.singularize }
    let!(:dependents_model_name) { dependent_model_factory_name || dependents_model_singular_name }

    before do
      if dependent_model_factory_name.nil?
        dependents_model = create dependents_model_singular_name
      else
        dependents_model = create dependent_model_factory_name
      end

      if dependents_model_singular_name != dependents_model_symbol.to_s
        model.send("#{dependents_model_symbol}=", [dependents_model])
      else
        model.send("#{dependents_model_symbol}=", dependents_model)
      end
      model.save!
    end

    context "when #{model_symbol} deleted" do
      it "deletes #{dependents_model_symbol} at the same time." do
        dependents_clazz = Module.const_get(dependents_model_name.to_s.camelize)
        expect { model.destroy }.to change(dependents_clazz, :count).by(-1)
      end
    end
  end
end
