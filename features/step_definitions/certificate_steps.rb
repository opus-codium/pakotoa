# frozen_string_literal: true

Étantdonné(/^un certificat "([^"]*)" signé par "(.*?)"$/) do |subject, issuer_subject|
  create(:certificate, issuer_id: CertificateAuthority.find_by(subject: issuer_subject).id, subject: subject)
end

Étantdonné(/^le certificat "([^"]*)" est révoqué$/) do |subject|
  Certificate.find_by(subject: subject).update(revoked_at: Time.zone.now)
end

Lorsqu("il créé un certificat avec ce CSR:") do |csr|
  click_on "Manage Certificates"
  click_on "Create Certificate"
  fill_in "Certificate Signing Request", with: csr
  click_on "Save"
end

Lorsqu("il créé un certificat avec ce CSR et le sujet {string}:") do |subject, csr|
  click_on "Manage Certificates"
  click_on "Create Certificate"
  fill_in "Certificate Signing Request", with: csr
  fill_in "Subject", with: subject
  click_on "Save"
end

Alors("il voit un certificat avec pour sujet {string}") do |subjet|
  expect(page).to have_content(subjet)
end
