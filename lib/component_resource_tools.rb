module ComponentResourceTools

  extend ActiveSupport::Concern

  def latest(other)
    (updated_values?(other) && ( other.last_updated > last_updated )) ? yield(self) : self
  end

  module ClassMethods

    def identify_by(*args)
      @identified_by = args
    end

    def create_or_update(attributes)
      new_atts = attributes.reverse_merge(:data => attributes)
      new_record = new(new_atts)
      where_conditions = Hash[@identified_by.map {|k| [k,new_atts[k.to_s]] }]
      for_lims(attributes.lims_id).where(where_conditions).first.latest(new_record) do |record|
        record.update_attributes(new_atts) if record.present?
        record ||= new_record
        record.save!
      end
    end
    private :create_or_update
  end
end
