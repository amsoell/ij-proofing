<!--#include file="authcheck.asp" -->
<!--#include virtual="/lib/notifications.asp" -->
<%
  Set objConn = Application("objConnection")

  sqlx = "UPDATE Task SET "
  sqlx = sqlx & "AssignedTo=" & replace(Session("id"), "'", "''") & ", "
  sqlx = sqlx & "AssignmentDate=CURRENT_TIMESTAMP, "
  sqlx = sqlx & "CreationDate=CreationDate WHERE id=" & request("id") & " AND AssignedTo IS NULL AND CreatedBy<>" & Session("id")

  objConn.execute(sqlx)

  '! Send notification

  sqlx = "SELECT c.Email, t.Description, t.ExpectedDelivery, t.RequestedReturn, t.Summary, a.Firstname + ' ' + a.Lastname AS Fullname FROM [User] c " & _
         "INNER JOIN Task t on t.CreatedBy=c.id " & _
         "INNER JOIN [User] a ON t.AssignedTo=a.id " & _
         "WHERE t.id=" & request("id")
  Set rs = objConn.execute(sqlx)

  if not rs.eof then

    body = "Your assignment has been claimed by <strong>" & rs("Fullname") & "</strong><br /><br />" & _
           "Assignment: " & rs("Description") & "<br />" & _
           "Available for Proofing Date: " & rs("ExpectedDelivery") & "<br />" & vbcrlf & _
           "Due Date: " & rs("RequestedReturn") & "<br />" & vbcrlf & _
           "Summary: " & rs("Summary")

    dispatchNotification rs("Email"), "Proofing Assignment Claimed: " & rs("Description"), body
  end if
%>
<!--#include file="assignments.asp" -->