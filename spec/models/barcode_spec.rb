require 'spec_helper'

describe Barcode do
  context 'with uuid' do
    it_behaves_like 'a component resource'


    let(:json) do
      {
        "barcodable_uuid" => "11111111-2222-3333-4444-555555555555",
        "barcodable_type" => "Plate",
        "machine_readable_barcode" => "1220000010734",
        "human_readable_barcode" => "DN10I",
        "barcode_type" => "SangerEan13"
      }
    end
  end
end
