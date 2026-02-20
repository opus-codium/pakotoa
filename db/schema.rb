# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.2].define(version: 2026_02_20_182855) do
  create_table "affiliations", force: :cascade do |t|
    t.integer "user_id"
    t.integer "certificate_authority_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.index ["certificate_authority_id"], name: "index_affiliations_on_certificate_authority_id"
    t.index ["user_id"], name: "index_affiliations_on_user_id"
  end

  create_table "certificates", force: :cascade do |t|
    t.string "serial"
    t.integer "issuer_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "type", default: "Certificate"
    t.string "subject"
    t.text "certificate"
    t.datetime "not_before", precision: nil
    t.datetime "not_after", precision: nil
    t.text "key"
    t.integer "policy_id"
    t.string "export_root"
    t.datetime "revoked_at", precision: nil
    t.string "certify_for", default: "2 years from now"
    t.string "crl_ttl", default: "1 week from now"
    t.string "next_serial"
    t.index ["issuer_id"], name: "index_certificates_on_issuer_id"
  end

  create_table "oids", force: :cascade do |t|
    t.string "name"
    t.string "short_name"
    t.string "oid"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "default_description"
    t.index ["name"], name: "index_oids_on_name", unique: true
  end

  create_table "policies", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "subject_attributes", force: :cascade do |t|
    t.integer "oid_id"
    t.integer "policy_id"
    t.string "default"
    t.integer "min"
    t.integer "max"
    t.string "strategy"
    t.integer "position"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "description"
    t.index ["oid_id"], name: "index_subject_attributes_on_oid_id"
    t.index ["policy_id"], name: "index_subject_attributes_on_policy_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.integer "sign_in_count", default: 0
    t.datetime "current_sign_in_at", precision: nil
    t.datetime "last_sign_in_at", precision: nil
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "time_zone"
    t.string "encrypted_password", default: "", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end
end
