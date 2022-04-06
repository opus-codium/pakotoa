# frozen_string_literal: true

class Oid < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  has_many :subject_attributes
end
