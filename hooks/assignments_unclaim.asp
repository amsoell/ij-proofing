<!--#include file="authcheck.asp" -->
<!--#include virtual="/lib/notifications.asp" -->
<%
  Set dbProofing = Application("objConnection_Proofing")


  '! Send notification
  sqlx = "SELECT t.CreatedByName AS created_by_name, t.CreatedByEmail AS created_by_email, t.Description, t.ExpectedDelivery, t.RequestedReturn, t.Summary, a.Firstname + ' ' + a.Lastname AS Fullname FROM Task t " & _
         "INNER JOIN [User] a ON t.AssignedTo=a.id " & _
         "WHERE t.id=" & request("id")
  Set rs = dbProofing.execute(sqlx)

  if not rs.eof then
    strDescription = rs("Description")
    created_by_email = rs("created_by_email")
    created_by_name = rs("created_by_name")

    sqlx = "UPDATE Task SET "
    sqlx = sqlx & "AssignedTo=NULL, "
    sqlx = sqlx & "AssignmentDate=NULL, "
    sqlx = sqlx & "CreationDate=CreationDate WHERE id=" & request("id") & " AND AssignedTo IS NOT NULL and CompletionDate IS NULL AND AssignedTo=" & Session("id")

    dbProofing.execute(sqlx)


    body = "A proofing assignment has become available from the Institute for Justice.  To claim this assignment, click here:<br /><br />" & vbcrlf & vbcrlf & _
           "http://proofing.ij.org/#/assignments/" & request("id") & "<br /><br />" & vbcrlf & vbcrlf & _
           "<strong>Assignment</strong>: " & rs("Description") & "<br />" & vbcrlf & _
           "<strong>Available for Proofing Date</strong>: " & rs("ExpectedDelivery") & "<br />" & vbcrlf & _
           "<strong>Due Date</strong>: " & rs("RequestedReturn") & "<br />" & vbcrlf & _
           "<strong>Summary</strong>: " & rs("Summary")

    sqlx = "SELECT FirstName, LastName, Email FROM [User] WHERE (Administrator=0 OR Administrator IS NULL) and LEN(Email)>0"
    Set rs = dbProofing.execute(sqlx)

    while not rs.eof
      dispatchNotification rs("Email"), "Proofing Assignment Available: " & strDescription, body, created_by_email, created_by_email
      rs.movenext
    wend
  end if

%>
<!--#include file="assignments.asp" -->