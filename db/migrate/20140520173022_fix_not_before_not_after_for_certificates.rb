# frozen_string_literal: true

class FixNotBeforeNotAfterForCertificates < ActiveRecord::Migration[4.2]
  def up
    Certificate.find_each do |certificate|
      cert = OpenSSL::X509::Certificate.new(certificate.certificate)
      certificate.update!(not_before: cert.not_before, not_after: cert.not_after)
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration, "This migration cannot be reverted"
  end
end
