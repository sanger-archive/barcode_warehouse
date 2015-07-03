shared_examples_for 'a component resource' do |components|
  let(:originally_created_at) { Time.parse('2012-Mar-16 12:06') }
  let(:timestamped_json) { json.merge("created_at" => originally_created_at, "updated_at" => originally_created_at) }
  let(:new_timestamped_json) { updated_json.merge("created_at" => originally_created_at, "updated_at" => originally_created_at) }
  let(:modified_at) { originally_created_at + 1.day }
  let(:checked_time_now) { Time.parse('2012-Mar-26 13:20').utc }
  let(:checked_time_then) { Time.parse('2012-Mar-25 13:20').utc }
  let(:example_lims) { 'example' }

  let(:attributes) { described_class.send(:json).new(timestamped_json) }
  let(:new_attributes) { described_class.send(:json).new(new_timestamped_json) }

  def current_records
    ActiveRecord::Base.connection.select_all("SELECT * FROM #{described_class.table_name}")
  end

  context '.create_or_update_from_json' do

    context 'from different lims' do

      # For all existing uses a different LIMS, with the same component identifiers, shouldn't be broadcasting
      # new records. If it does we probably DO want to deadletter it, as it indicates a problem.

      let(:second_lims) { 'example_2' }

      before(:each) do
        described_class.create_or_update_from_json(timestamped_json.merge("updated_at" => modified_at), example_lims)
      end

      it 'raises an exception' do
        expect { described_class.create_or_update_from_json(timestamped_json.merge("updated_at" => modified_at), second_lims) }.to raise_error(ActiveRecord::RecordNotUnique)
      end
    end

    context 'without existing records' do

      let(:recorded_time) { checked_time_now }

      context 'when the record is deleted' do

        let(:most_recent_time) { modified_at }


        before(:each) do
          allow(described_class).to receive(:checked_time_now).and_return(checked_time_now)
          described_class.send(:create_or_update, attributes.merge("updated_at" =>modified_at,"deleted_at" => modified_at,:lims_id=>example_lims))
        end

        it 'flags the record as deleted' do
          expect(current_records.count).to eq(1)
          expect(current_records.first['deleted_at']).to eq(modified_at)
        end
      end

      context 'when the record is new' do

        let(:most_recent_time) { originally_created_at }
        before(:each) do
          allow(described_class).to receive(:checked_time_now).and_return(checked_time_now)
          described_class.create_or_update_from_json(timestamped_json,example_lims)
        end

        it_behaves_like 'has only one row'
      end
    end

    context 'with an existing record' do

      before(:each) do
        allow(described_class).to receive(:checked_time_now).and_return(checked_time_then)
        described_class.create_or_update_from_json(timestamped_json.merge("updated_at" => modified_at), example_lims)
      end

      context 'when the new record is not current' do
        before(:each) do
          described_class.send(:create_or_update, attributes.merge("updated_at" => modified_at - 2.hours, :lims_id=>example_lims))
        end

        it 'only has the current row in the view' do
          expect(current_records.count).to eq(1)
          expect(current_records.first['last_updated']).to eq(modified_at)
        end
      end

      context 'when the fields are unchanged' do

        let(:most_recent_time) { modified_at }
        let(:recorded_time) { checked_time_then }

        before(:each) do
          allow(described_class).to receive(:checked_time_now).and_return(checked_time_now)
          described_class.create_or_update_from_json(timestamped_json.merge("updated_at" => modified_at), example_lims)
        end

        it_behaves_like 'has only one row'
      end

      context 'when ignored fields change' do
        ResourceTools::IGNOREABLE_ATTRIBUTES.each do |attribute|
          next if attribute.to_s == 'dont_use_id' # Protected by mass-assignment!

          let(:most_recent_time) { modified_at }
          let(:recorded_time) { checked_time_then }

          context "when #{attribute.to_sym.inspect} changes" do
            before(:each) do
              # We have to account for attribute translation, so process through the JSON handler
              # and then update the attribute.
              allow(described_class).to receive(:checked_time_now).and_return(checked_time_now)
              attributes[attribute] = 'changed'
              described_class.send(:create_or_update, attributes.merge("updated_at" => modified_at,:lims_id =>example_lims))
            end

            it_behaves_like 'has only one row'
          end
        end
      end

      components.each do |changeable,changeable_value|
        context "when #{changeable} changes" do
          before(:each) do
            described_class.send(:create_or_update, new_attributes.merge("updated_at" => modified_at + 2.hours, :lims_id=>example_lims, changeable.to_s => changeable_value))
          end

          it 'creates a new record' do
            expect(current_records.count).to eq(2)
            expect(current_records.last['last_updated']).to eq(modified_at + 2.hours )
          end
        end
      end

    end
  end
end
