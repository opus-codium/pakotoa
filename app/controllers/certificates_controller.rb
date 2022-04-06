# frozen_string_literal: true

class CertificatesController < ApplicationController
  before_action do
    @certificate_authority = current_user.certificate_authorities.find(params[:certificate_authority_id])
  end

  add_breadcrumb "certificate_authorities.index.title", "certificate_authorities_path"
  add_breadcrumb :certificate_authority_title, "certificate_authority_path(@certificate_authority)"
  add_breadcrumb "certificates.index.title", "certificate_authority_certificates_path(@certificate_authority)", except: :index

  # GET /certificates
  def index
    @certificates = Certificate.signed_by(@certificate_authority.subject).order("created_at DESC")
  end

  # GET /certificates/1
  def show
    @certificate = Certificate.find(params[:id])
    respond_to do |format|
      format.html
      format.der { render body: @certificate.certificate.to_der }
      format.pem { render body: @certificate.certificate.to_pem }
    end
  end

  # GET /certificates/new
  def new
    @certificate = @certificate_authority.certificates.new
  end

  # POST /certificates
  def create
    case params[:certificate][:method]
    when "csr"
      @certificate = @certificate_authority.sign_certificate_request(params[:certificate][:csr], subject_override: params[:certificate][:subject])
    when "spkac"
      if params[:public_key].nil?
        @certificate.errors.add(:public_key, :not_set)
      else
        @certificate.save
        f = File.new("/tmp/key.spkac", "w")
        f.write("SPKAC=#{params[:public_key].split.join}\n")
        attr_usage = {}
        @certificate_authority.subject_attributes.order("position").each_with_index do |attr, i|
          attr_usage[attr.oid.name] ||= 0
          value = params["attr_#{i}"] || attr.default
          if ! value.blank? then
            f.write("#{attr_usage[attr.oid.name]}.#{attr.oid.name}=#{value}\n")
          end
          attr_usage[attr.oid.name] += 1
        end
        f.close
        # openssl ca -config config/ssl/openssl.cnf -name CA_foo -spkac /tmp/key.spkac -batch
      end
    when "insecure"
    end
    if @certificate.persisted?
      redirect_to [@certificate_authority, @certificate], notice: "Certificate was successfully created."
    else
      render "new", status: :unprocessable_entity
    end
  end

  def revoke
    @certificate = Certificate.find(params[:id])
    @certificate.update(revoked_at: Time.now.utc)
    redirect_to [@certificate_authority, @certificate], notice: "Certificate was successfully revoked."
  end

  # DELETE /certificates/1
  def destroy
    @certificate = Certificate.find(params[:id])
    @certificate.destroy
    redirect_to certificate_authority_certificates_path(@certificate_authority), notice: "Certificate was successfully removed."
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def certificate_params
      params.require(:certificate).permit(:method, :csr)
    end
end
