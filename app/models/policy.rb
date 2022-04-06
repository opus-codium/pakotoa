# frozen_string_literal: true

class Policy < ApplicationRecord
  has_many :subject_attributes, dependent: :destroy
  has_many :certificate_authority, dependent: :restrict_with_error
end
