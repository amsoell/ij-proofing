<%
function dispatchNotification(mail_to, mail_subject, mail_body)
  if len(mail_to)>0 then
    Set cdoConfig = Server.CreateObject("CDO.Configuration")
    cdoConfig.Fields.Item("http://schemas.microsoft.com/cdo/configuration/sendusing") = 2
    cdoConfig.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpserver") = Application("SMTP_SERVER")
    cdoConfig.fields.update
    
    set mail = Server.CreateObject ("CDO.Message")
    mail.Configuration  = cdoConfig
    mail.From    		    = "IJ Proofing Assignment System <proofingadmins@ij.org>"
    mail.To             = mail_to
    mail.Subject        = mail_subject
    mail.HTMLBody       = mail_body
  
    dispatchNotification = mail.send
    set mail = nothing
    set cdoConfig = nothing
  end if
end function
%>