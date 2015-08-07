<%

function dispatchNotification(mail_to, mail_subject, mail_body, mail_from, mail_replyto)
  debugMode = false

  if IsNull(mail_from) then
    send_from = "IJ Proofing Assignment System <proofingadmins@ij.org>"
  else
    send_from = mail_from
  end if

  if len(mail_to)>0 then
    Set cdoConfig = Server.CreateObject("CDO.Configuration")
    cdoConfig.Fields.Item("http://schemas.microsoft.com/cdo/configuration/sendusing") = 2
    cdoConfig.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpserver") = Application("SMTP_SERVER")
    cdoConfig.fields.update

    set mail = Server.CreateObject ("CDO.Message")
    mail.Configuration      = cdoConfig
    mail.From               = send_from
    if debugMode then
      mail.to               = mail_to & " <amsoell@ij.org>"
    else
      mail.To               = mail_to
    end if
    mail.Subject            = mail_subject
    if Not IsNull(mail_replyto) then
      mail.ReplyTo          = mail_reply_to
    end if
    mail.HTMLBody           = mail_body

    dispatchNotification    = mail.send
    set mail = nothing
    set cdoConfig = nothing
  end if
end function
%>