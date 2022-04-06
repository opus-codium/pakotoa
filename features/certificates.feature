# language: fr

Fonctionnalité: Certificats
  Scénario: Création d'un certificat avec un CSR
    Étant donné un administrateur
    Et une autorité de certification "/C=FR/O=Pakotoa"
    Lorsqu'il créé un certificat avec ce CSR:
      """
      -----BEGIN CERTIFICATE REQUEST-----
      MIICWzCCAUMCAQAwFjEUMBIGA1UEAwwLZXhhbXBsZS5jb20wggEiMA0GCSqGSIb3
      DQEBAQUAA4IBDwAwggEKAoIBAQDj2Wr3CUPQ8sRC2HAlkuPs1C9DJPaQepkw6nJZ
      6h9J9ms5ABqcHsLZemVXjIY6Lpi0CJ/Thp7Mw31xpbhIF9SFJmjF3IC4VQ9etKOz
      HZ24Z88rAqny2DjwKxHT+0qBr90jOlE3BXJSN+jqybRKY4LUd7YQ2KD1qz0MQHth
      /ZcnSEkxf3YnxVyBO9DmAG6Tl0nvFTnlT/QTZENN4rhcmGIj5Fbqu4/4O3ObQ3vY
      p0DJl4AvHLMxi6JZ7wTynWi6OEjUNSICEgOMBMaACwfcFcBygKFWhcB8D6SMHGYR
      CuQHdrvE69y/6sw/fRURwaQgaJD5CCm5IEISIJWdqfyvU2j1AgMBAAGgADANBgkq
      hkiG9w0BAQsFAAOCAQEAlzBFpDvIaBvItvlrkkfET4wlD3MAFQ+e9w9BaFD0ExLA
      mrcOTxtGwoMAJnWJZvI+/Qyd1laZnvSa03OHN/IC143S0ty/OuEGWAKJ6EdpbHEm
      rQ98e7FQ/VL7Kw43i3HgqjPy6V+q/+soW+hcMx2dS2aR6UwDspuwIUJ3SOvmnL2Y
      6P9NzECEGOFrfaNQKNtqxapuQffi/Pn5/OYvtj79U5pPeB9g6RBd70pTFH7hROb4
      FjgNB9dnXISS0lmRv7gly+TsvP9UNflUd2WzzmfABSVkexoY2tpBeE3HwtE5FPYJ
      SJD1kM4LQEQs9PasgSSaZI4PPoP5+1gexmTgrkDXtw==
      -----END CERTIFICATE REQUEST-----
      """
  Alors il voit un certificat avec pour sujet "/CN=example.com"

  Scénario: Réécriture du sujet d'un certificat
    Étant donné un administrateur
    Et une autorité de certification "/C=FR/O=Pakotoa"
    Lorsqu'il créé un certificat avec ce CSR et le sujet "/CN=overriden.example.com":
      """
      -----BEGIN CERTIFICATE REQUEST-----
      MIICWzCCAUMCAQAwFjEUMBIGA1UEAwwLZXhhbXBsZS5jb20wggEiMA0GCSqGSIb3
      DQEBAQUAA4IBDwAwggEKAoIBAQDj2Wr3CUPQ8sRC2HAlkuPs1C9DJPaQepkw6nJZ
      6h9J9ms5ABqcHsLZemVXjIY6Lpi0CJ/Thp7Mw31xpbhIF9SFJmjF3IC4VQ9etKOz
      HZ24Z88rAqny2DjwKxHT+0qBr90jOlE3BXJSN+jqybRKY4LUd7YQ2KD1qz0MQHth
      /ZcnSEkxf3YnxVyBO9DmAG6Tl0nvFTnlT/QTZENN4rhcmGIj5Fbqu4/4O3ObQ3vY
      p0DJl4AvHLMxi6JZ7wTynWi6OEjUNSICEgOMBMaACwfcFcBygKFWhcB8D6SMHGYR
      CuQHdrvE69y/6sw/fRURwaQgaJD5CCm5IEISIJWdqfyvU2j1AgMBAAGgADANBgkq
      hkiG9w0BAQsFAAOCAQEAlzBFpDvIaBvItvlrkkfET4wlD3MAFQ+e9w9BaFD0ExLA
      mrcOTxtGwoMAJnWJZvI+/Qyd1laZnvSa03OHN/IC143S0ty/OuEGWAKJ6EdpbHEm
      rQ98e7FQ/VL7Kw43i3HgqjPy6V+q/+soW+hcMx2dS2aR6UwDspuwIUJ3SOvmnL2Y
      6P9NzECEGOFrfaNQKNtqxapuQffi/Pn5/OYvtj79U5pPeB9g6RBd70pTFH7hROb4
      FjgNB9dnXISS0lmRv7gly+TsvP9UNflUd2WzzmfABSVkexoY2tpBeE3HwtE5FPYJ
      SJD1kM4LQEQs9PasgSSaZI4PPoP5+1gexmTgrkDXtw==
      -----END CERTIFICATE REQUEST-----
      """
  Alors il voit un certificat avec pour sujet "/CN=overriden.example.com"

  Scénario: Révocation de certificats
    Étant donné un administrateur
    Et une autorité de certification "/C=FR/O=Pakotoa"
    Et un certificat "/C=FR/O=Pakotoa/CN=TEST 1" signé par "/C=FR/O=Pakotoa"
    Lorsqu'il visite la page des certificats de l'autorité de certification "/C=FR/O=Pakotoa"
    Alors il voit 1 liens "Revoke"
    Étant donné 5 minutes s'écoulent
    Et un certificat "/C=FR/O=Pakotoa/CN=TEST 2" signé par "/C=FR/O=Pakotoa"
    Lorsqu'il visite la page des certificats de l'autorité de certification "/C=FR/O=Pakotoa"
    Alors il voit 2 liens "Revoke"
    Étant donné le certificat "/C=FR/O=Pakotoa/CN=TEST 1" est révoqué
    Lorsqu'il visite la page des certificats de l'autorité de certification "/C=FR/O=Pakotoa"
    Alors il voit 1 liens "Revoke"
    Étant donné 20 minutes s'écoulent
    Lorsqu'il visite la page des certificats de l'autorité de certification "/C=FR/O=Pakotoa"
    Alors il voit 0 liens "Revoke"
