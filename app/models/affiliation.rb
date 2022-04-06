# frozen_string_literal: true

class Affiliation < ApplicationRecord
  belongs_to :user
  belongs_to :certificate_authority
end
