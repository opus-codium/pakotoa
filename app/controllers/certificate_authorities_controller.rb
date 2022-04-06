# frozen_string_literal: true

class CertificateAuthoritiesController < ApplicationController
  add_breadcrumb "certificate_authorities.index.title", "certificate_authorities_path", except: :index

  # GET /certificate_authorities
  # GET /certificate_authorities.json
  def index
    @certificate_authorities = current_user.certificate_authorities.all.order("created_at DESC")
  end

  # GET /certificate_authorities/1
  # GET /certificate_authorities/1.json
  def show
    @certificate_authority = current_user.certificate_authorities.find(params[:id])
    respond_to do |format|
      format.html
      format.crl { render body: @certificate_authority.crl.to_pem }
      format.der { render body: @certificate_authority.certificate.to_der }
      format.pem { render body: @certificate_authority.certificate.to_pem }
    end
  end

  def full_chain
    @certificate_authority = current_user.certificate_authorities.find(params[:id])
    respond_to do |format|
      format.pem { render body: @certificate_authority.full_chain_pem }
    end
  end

  # GET /certificate_authorities/1/openssl_req
  def openssl_req
    @certificate_authority = current_user.certificate_authorities.find(params[:id])
    render layout: false
  end

  # GET /certificate_authorities/1/openssl_ca
  def openssl_ca
    @certificate_authority = current_user.certificate_authorities.find(params[:id])
    render layout: false
  end

  # GET /certificate_authorities/new
  def new
    @certificate_authority = current_user.certificate_authorities.new
  end

  # POST /certificate_authorities
  # POST /certificate_authorities.json
  def create
    @certificate_authority = current_user.certificate_authorities.new(certificate_authority_params)

    if !@certificate_authority.save
      render "new", status: :unprocessable_entity
      return
    end

    current_user.certificate_authorities << @certificate_authority

    key = OpenSSL::PKey::RSA.new(@certificate_authority.key_length.to_i)
    @certificate_authority.key = key

    certificate = OpenSSL::X509::Certificate.new

    subject = OpenSSL::X509::Name.parse(@certificate_authority.subject)
    if @certificate_authority.issuer then
      @issuer = @certificate_authority.issuer
      issuer_certificate = @issuer.certificate
      issuer_subject = OpenSSL::X509::Name.parse(@certificate_authority.issuer.subject)
      @issuer.password = params[:certificate_authority][:issuer_password]
    else
      @issuer = @certificate_authority
      issuer_certificate = certificate
      issuer_subject = subject
      @certificate_authority.next_serial = Random.rand(2**64)
    end

    certificate.version = 2
    certificate.serial = @issuer.next_serial!
    certificate.subject = subject
    certificate.issuer = issuer_subject
    certificate.public_key = key.public_key
    certificate.not_before = Time.now
    certificate.not_after = Chronic.parse(@certificate_authority.valid_until)
    ef = OpenSSL::X509::ExtensionFactory.new
    ef.subject_certificate = certificate
    ef.issuer_certificate = issuer_certificate
    certificate.add_extension(ef.create_extension("basicConstraints", "CA:TRUE", true))
    certificate.add_extension(ef.create_extension("keyUsage", "keyCertSign, cRLSign", true))
    certificate.add_extension(ef.create_extension("subjectKeyIdentifier", "hash", false))
    certificate.add_extension(ef.create_extension("authorityKeyIdentifier", "keyid:always", false))
    @issuer.sign(certificate)

    @certificate_authority.certificate = certificate

    if @certificate_authority.save
      redirect_to @certificate_authority, notice: "Certificate authority was successfully created."
    else
      render "new", status: :unprocessable_entity
    end
  rescue Exception => e
    @certificate_authority.destroy
    @certificate_authority.errors.add(:issuer_password, e.message + "" + e.backtrace.join("<br/>"))
    render "new", status: :unprocessable_entity
  end

  def edit
    @certificate_authority = current_user.certificate_authorities.find(params[:id])
  end

  def update
    @certificate_authority = current_user.certificate_authorities.find(params[:id])

    current_password = params[:certificate_authority].delete(:current_password)
    @certificate_authority.assign_attributes(params.require(:certificate_authority).permit(:policy_id, :certify_for, :export_root, :crl_ttl))

    if @certificate_authority.valid? then
      if @certificate_authority.password != current_password then
        @certificate_authority.password = current_password
        key = @certificate_authority.key
        @certificate_authority.password = params[:certificate_authority][:password]
        @certificate_authority.key = key
      end
      @certificate_authority.save
      redirect_to @certificate_authority, notice: "Certificate authority was successfully updated."
    end
  end

  # DELETE /certificate_authorities/1
  # DELETE /certificate_authorities/1.json
  def destroy
    @certificate_authority = current_user.certificate_authorities.find(params[:id])
    @certificate_authority.destroy
    redirect_to certificate_authorities_path, notice: "Certificate authority was successfully removed."
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def certificate_authority_params
      params.require(:certificate_authority).permit(:subject, :key_length, :password, :password_confirmation, :issuer_id, :issuer_password, :current_password, :policy_id, :export_root, :valid_until, :certify_for, :crl_ttl)
    end
end
