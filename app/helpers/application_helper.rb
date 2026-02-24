# frozen_string_literal: true

module ApplicationHelper
  def navbar_link_to(text, url, options = {})
    classes = ["navbar-item"]
    classes << "is-active" if request.path.start_with?(url)
    link_to text, url, options.merge(class: classes.join(" "))
  end

  def certificate_icon(certificate, options = {})
    if certificate.revoked_at.nil? && certificate.not_after.future?
      fa_icon("certificate", options)
    else
      options[:class] = "text-danger"
      if certificate.revoked_at
        fa_icon("ban", options)
      else
        fa_icon("clock-o", options)
      end
    end
  end
end
