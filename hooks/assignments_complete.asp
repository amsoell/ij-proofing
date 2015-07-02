<!--#include file="authcheck.asp" -->
<!--#include virtual="/lib/notifications.asp" -->
<%
  Set objConn = Application("objConnection")

  if IsNumeric(request("time_to_complete")) then
    sqlx = "UPDATE Task SET "
    sqlx = sqlx & "TimeToComplete=" & request("time_to_complete") & ", "
    sqlx = sqlx & "CompletionDate=CURRENT_TIMESTAMP, "
    sqlx = sqlx & "CreationDate=CreationDate WHERE id=" & request("id") & " AND AssignedTo IS NOT NULL AND (CreatedBy=" & Session("id") & " OR AssignedTo=" & Session("id") & ")"
    objConn.execute(sqlx)

    '! Send notification

    sqlx = "SELECT c.Email, t.Description, t.ExpectedDelivery, t.RequestedReturn, t.Summary, t.[Case], t.Program, a.FirstName + ' ' + a.LastName AS Fullname, t.TimeToComplete, a.Compensation, a.Address FROM [User] c " & _
           "INNER JOIN Task t on t.CreatedBy=c.id " & _
           "INNER JOIN [User] a ON t.AssignedTo=a.id " & _
           "WHERE t.id=" & request("id")
    Set rs = objConn.execute(sqlx)

    if not rs.eof then
      '! - To the creator...
      body = "Your assignment has been completed by <strong>" & rs("Fullname") & "</strong><br /><br />" & _
             "Assignment: " & rs("Description") & "<br />" & _
             "Available for Proofing Date: " & rs("ExpectedDelivery") & "<br />" & vbcrlf & _
             "Due Date: " & rs("RequestedReturn") & "<br />" & vbcrlf & _
             "Summary: " & rs("Summary")

      dispatchNotification rs("Email"), "Proofing Assignment Completed: " & rs("Description"), body

      '! - ...and to accounting
      body = "Please pay <strong>" & rs("Fullname") & "</strong> for completing the following proofing assignment:<br /><br />" & vbcrlf & vbcrlf & _
             "Invoice Number: " & request("id") & "<br />" & vbcrlf &  _
             "Case Code & Program: " & rs("Case") & "-" & rs("Program") & "<br />" & vbcrlf & _
             "Hours: " & rs("TimeToComplete") & "<br />" & vbcrlf & _
             "Rate: " & rs("Compensation") & "<br />" & vbcrlf
      if IsNumeric(rs("TimeToComplete")) and IsNumeric(rs("Compensation")) then
        invoiceTotal = rs("TimeToComplete") * rs("Compensation")
        body = body & "Total: " & invoiceTotal & "<br />" & vbcrlf
      end if

      body = body & vbcrlf & "<br />" & _
             "Please mail check to: <br />" & vbcrlf & _
             rs("Address")

      dispatchNotification "amsoell@ij.org", "Proofing Assignment Invoice #" & request("id") & " for " & rs("Description"), body
  end if


  else
    response.write "{ ""success"": false }"
    response.end
  end if
%>
<!--#include file="assignments.asp" -->