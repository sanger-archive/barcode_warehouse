class Barcode < ActiveRecord::Base
  include ResourceTools
  include ComponentResourceTools
  extend Uuidable

  # Each barcodable can have only one barcode of each type
  identify_by :barcodable_uuid, :barcode_type

  json do


  end

end
