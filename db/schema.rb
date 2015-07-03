# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150703152243) do

  create_table "barcodes", force: true do |t|
    t.string   "machine_readable_barcode",            null: false, comment: "The barcode as read by a scanner"
    t.string   "human_readable_barcode",              null: false, comment: "The barcode in a form easily read by humans. May be the same as the machine form."
    t.string   "barcode_type",                        null: false, comment: "String identifying the barcode format."
    t.string   "barcodable_type",                     null: false, comment: "Identifies the type of item that is barcoded. eg. Plate"
    t.binary   "barcodable_uuid",          limit: 16, null: false, comment: "Binary encoded UUID of the barcoded item."
    t.datetime "last_updated",                        null: false, comment: "Used internally to ensure the warehouse tracks only the most recent barcode. May not correspond to an actual change in the barcode itself."
    t.datetime "created",                             null: false, comment: "Date at which the barcodable was created"
    t.datetime "recorded_at",                         null: false, comment: "Date at which the barcode was last updated in the warehouse"
    t.datetime "deleted_at",                                       comment: "Date at which the barcodeable was destroyed"
    t.string   "lims_id",                             null: false, comment: "Identifier for the originating LIMS. eg. SQSCP for Sequencesacape"
  end

  add_index "barcodes", ["barcodable_uuid", "barcodable_type"], name: "index_barcodes_on_barcodable_uuid_and_barcodable_type", unique: true, using: :btree
  add_index "barcodes", ["machine_readable_barcode", "barcodable_type"], name: "index_barcodes_on_machine_readable_barcode_and_barcodable_type", unique: true, using: :btree

end
