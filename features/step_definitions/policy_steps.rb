# frozen_string_literal: true

Lorsqu("il créé une policy {string}") do |name|
  click_on "Policies"
  click_on "New policy"
  fill_in "Name", with: name
  click_on "Create Policy"

  click_on "New Attribute"
  fill_in "Default", with: "FR"
  click_on "Create Subject attribute"
  click_on "Back"

  click_on "New Attribute"
  select "commonName", from: "Oid"
  select "supplied", from: "Strategy"
  click_on "Create Subject attribute"
  click_on "Back"
end
