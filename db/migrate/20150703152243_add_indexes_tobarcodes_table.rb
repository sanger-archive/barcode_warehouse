class AddIndexesTobarcodesTable < ActiveRecord::Migration
  def change
    add_index :barcodes, [:barcodable_uuid, :barcode_type], unique: true
    add_index :barcodes, [:machine_readable_barcode, :barcode_type], unique: true
  end
end
