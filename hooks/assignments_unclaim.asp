<!--#include file="authcheck.asp" -->
<!--#include virtual="/lib/notifications.asp" -->
<%
  Set objConn = Application("objConnection")


  '! Send notification
  sqlx = "SELECT c.Email, t.Description, t.ExpectedDelivery, t.RequestedReturn, t.Summary, a.Firstname + ' ' + a.Lastname AS Fullname, c.EmpID FROM [User] c " & _
         "INNER JOIN Task t on t.CreatedBy=c.id " & _
         "INNER JOIN [User] a ON t.AssignedTo=a.id " & _
         "WHERE t.id=" & request("id")
  Set rs = objConn.execute(sqlx)

  if not rs.eof then
    strDescription = rs("Description")

    sqlx = "UPDATE Task SET "
    sqlx = sqlx & "AssignedTo=NULL, "
    sqlx = sqlx & "AssignmentDate=NULL, "
    sqlx = sqlx & "CreationDate=CreationDate WHERE id=" & request("id") & " AND AssignedTo IS NOT NULL and CompletionDate IS NULL AND (AssignedTo=" & Session("id") & " OR CreatedBy=" & Session("id") & ")"

    objConn.execute(sqlx)


    body = "A proofing assignment has become available from the Institute for Justice.  To claim this assignment, click here:<br /><br />" & vbcrlf & vbcrlf & _
           "http://proofing.ij.org/#/assignments/" & request("id") & "<br /><br />" & vbcrlf & vbcrlf & _
           "Assignment: " & rs("Description") & "<br />" & vbcrlf & _
           "Available for Proofing Date: " & rs("ExpectedDelivery") & "<br />" & vbcrlf & _
           "Due Date: " & rs("RequestedReturn") & "<br />" & vbcrlf & _
           "Summary: " & rs("Summary")

    sqlx = "SELECT FirstName, LastName, Email FROM [User] WHERE (Administrator=0 OR Administrator IS NULL) and LEN(Email)>0"
    Set rs = objConn.execute(sqlx)

    while not rs.eof
      dispatchNotification rs("Email"), "Proofing Assignment Available: " & strDescription, body
      rs.movenext
    wend
  end if

%>
<!--#include file="assignments.asp" -->