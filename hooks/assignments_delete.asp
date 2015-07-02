<!--#include file="authcheck.asp" -->
<%
  Set objConn = Application("objConnection")


  '! Send notification
  if request("id")>0 then

    sqlx = "SELECT c.Email, t.Description, t.ExpectedDelivery, t.RequestedReturn, t.Summary, a.Firstname+' '+a.Lastname AS Fullname FROM [User] c " & _
           "INNER JOIN Task t on t.CreatedBy=c.id " & _
           "INNER JOIN [User] a ON t.AssignedTo=a.id " & _
           "WHERE t.id=" & request("id")
    Set rs = objConn.execute(sqlx)

    if not rs.eof then

      body = "Your assignment has been deleted<br /><br />" & _
             "Assignment: " & rs("Description") & "<br />" & _
             "Available for Proofing Date: " & rs("ExpectedDelivery") & "<br />" & vbcrlf & _
             "Due Date: " & rs("RequestedReturn") & "<br />" & vbcrlf & _
             "Summary: " & rs("Summary")

      dispatchNotification rs("Email"), "Proofing Assignment Deleted: " & rs("Description"), body
    end if

    '! Delete notification
    sqlx = "DELETE TOP (1) FROM Task WHERE id=" & request("id") & " AND CreatedBy=" & Session("id")
    Set rs = objConn.execute(sqlx)
%>
{ "success": true }
<%
  else
%>
{ "success": false }
<%
  end if
%>