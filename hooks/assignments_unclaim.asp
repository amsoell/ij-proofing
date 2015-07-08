<!--#include file="authcheck.asp" -->
<!--#include virtual="/lib/notifications.asp" -->
<%
  Set objConn = Application("objConnection")


  '! Send notification
  sqlx = "SELECT c.Email, t.Description, t.ExpectedDelivery, t.RequestedReturn, t.Summary, a.Firstname + ' ' + a.Lastname AS Fullname, c.id, c.Email AS created_by_email FROM [User] c " & _
         "INNER JOIN Task t on t.CreatedBy=c.id " & _
         "INNER JOIN [User] a ON t.AssignedTo=a.id " & _
         "WHERE t.id=" & request("id")
  Set rs = objConn.execute(sqlx)

  if not rs.eof then
    strDescription = rs("Description")
    created_by_email = rs("created_by_email")

    sqlx = "UPDATE Task SET "
    sqlx = sqlx & "AssignedTo=NULL, "
    sqlx = sqlx & "AssignmentDate=NULL, "
    sqlx = sqlx & "CreationDate=CreationDate WHERE id=" & request("id") & " AND AssignedTo IS NOT NULL and CompletionDate IS NULL AND (AssignedTo=" & Session("id") & " OR CreatedBy=" & Session("id") & ")"

    objConn.execute(sqlx)


    body = "A proofing assignment has become available from the Institute for Justice.  To claim this assignment, click here:<br /><br />" & vbcrlf & vbcrlf & _
           "http://proofing.ij.org/#/assignments/" & request("id") & "<br /><br />" & vbcrlf & vbcrlf & _
           "<strong>Assignment</strong>: " & rs("Description") & "<br />" & vbcrlf & _
           "<strong>Available for Proofing Date</strong>: " & rs("ExpectedDelivery") & "<br />" & vbcrlf & _
           "<strong>Due Date</strong>: " & rs("RequestedReturn") & "<br />" & vbcrlf & _
           "<strong>Summary</strong>: " & rs("Summary")

    sqlx = "SELECT FirstName, LastName, Email FROM [User] WHERE (Administrator=0 OR Administrator IS NULL) and LEN(Email)>0"
    Set rs = objConn.execute(sqlx)

    while not rs.eof
      dispatchNotification rs("Email"), "Proofing Assignment Available: " & strDescription, body, created_by_email, created_by_email
      rs.movenext
    wend
  end if

%>
<!--#include file="assignments.asp" -->