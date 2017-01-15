module CodeMaster
  def self.included(base)
    base.send :extend, ClassMethods
  end

  module ClassMethods
    def acts_as_code_master(property, values)
      define_method "master_code?" do |o|
        code = self.respond_to?(property) ? self.send(property) : nil
        code.nil? ? false : code.to_s == o.to_s
      end

      define_method "master_codes" do
        values
      end

      values.each do |o|
        define_method "#{o}?" do
          code = self.respond_to?(property) ? self.send(property) : nil
          code.nil? ? false : code.to_s == o.to_s
        end
      end

      (class << self; self; end).class_eval do
        define_method "master_codes" do
          values
        end
      end
    end
  end
end
