# frozen_string_literal: true

class SubjectAttribute < ApplicationRecord
  acts_as_list

  validate :default_value_minimum_length, :default_value_maximum_length
  validates :strategy, inclusion: ["match", "optional", "supplied"], presence: true
  validates_associated :oid, :policy

  belongs_to :oid
  belongs_to :policy

  before_save do
    self.description = oid.default_description if description.blank?
  end

  def default_value_minimum_length
    if default && min && default.length < min
      errors.add :default, "does not match minimum lenght requirement"
      errors.add :min, "is not short enough to accomodate default value"
    end
  end

  def default_value_maximum_length
    if default && max && default.length > max
      errors.add :default, "does not match maximum length requirement"
      errors.add :max, "is not large enough to accomodate default value"
    end
  end
end
