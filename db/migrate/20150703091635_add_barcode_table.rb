class AddBarcodeTable < ActiveRecord::Migration
  def change
    create_table :barcodes do |t|
      t.string    :machine_readable_barcode, null:false, comment: "The barcode as read by a scanner"
      t.string    :human_readable_barcode,   null:false, comment: "The barcode in a form easily read by humans. May be the same as the machine form."
      t.string    :barcode_type,             null:false, comment: "String identifying the barcode format."
      t.string    :barcodable_type,          null:false, comment: "Identifies the type of item that is barcoded. eg. Plate"
      t.binary    :barcodable_uuid,          null:false, comment: "Binary encoded UUID of the barcoded item.", limit: 16
      t.datetime  :last_updated,             null:false, comment: "Used internally to ensure the warehouse tracks only the most recent barcode. May not correspond to an actual change in the barcode itself."
      t.datetime  :created,                  null:false, comment: "Date at which the barcodable was created"
      t.datetime  :recorded_at,              null:false, comment: "Date at which the barcode was last updated in the warehouse"
      t.datetime  :deleted_at,               null:true,  comment: "Date at which the barcodeable was destroyed"
      t.string    :lims_id,                  null:false, comment: "Identifier for the originating LIMS. eg. SQSCP for Sequencesacape"
    end
  end
end
