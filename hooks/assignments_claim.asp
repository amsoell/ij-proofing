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

  sqlx = "SELECT c.Email, t.Description, t.ExpectedDelivery, t.RequestedReturn, t.Summary, a.Firstname + ' ' + a.Lastname AS Fullname, c.Firstname AS created_by_firstname, c.Email as created_by_email FROM [User] c " & _
         "INNER JOIN Task t on t.CreatedBy=c.id " & _
         "INNER JOIN [User] a ON t.AssignedTo=a.id " & _
         "WHERE t.id=" & request("id")
  Set rs = objConn.execute(sqlx)

  if not rs.eof then
    created_by_firstname    = rs("created_by_firstname")
    created_by_email        = rs("created_by_email")
    claimed_by_name         = rs("Fullname")
    description             = rs("Description")
    expected_delivery       = rs("ExpectedDelivery")
    requested_return        = rs("RequestedReturn")
    summary                 = rs("Summary")

    '!Send email to Creator
    '
    ' Template:
    '  To: [Requester]; [Proofing Admins]
    '  From: IJ Proofing Assignment System
    '  Reply to: proofingadmins@ij.org
    '  Subject:Proofing Assignment Submitted [assignment description]
    '  Body:
    '         To: [External Proofers]; [Requester]; [Proofing Admins]
    '         From: IJ Proofing Assignment System
    '         Reply to: Requester; Proofing Admins
    '         Subject: Proofing Assignment Claimed[assignment description]
    '         Body:
    '
    '         [First Name of Requester],
    '
    '         Your assignment has been claimed by [proofer first name, proofer last name].
    '
    '         Assignment: [Assignment Description]
    '         Available for Proofing Date: [Delivery Date]
    '         Due Date: [Due Date]
    '         Summary: [Assignment Summary]
    '         --------------------------------------------------------------------------------------

    body = created_by_firstname & ",<br /><br />" & _
           "Your assignment has been claimed by <strong>" & claimed_by_name & "</strong><br /><br />" & _
           "<strong>Assignment</strong>: " & description & "<br />" & _
           "<strong>Available for Proofing Date</strong>: " & expected_delivery & "<br />" & vbcrlf & _
           "<strong>Due Date</strong>: " & requested_return & "<br />" & vbcrlf & _
           "<strong>Summary</strong>: " & summary

    ' One to the creator...
    dispatchNotification created_by_email, "Proofing Assignment Claimed " & rs("Description"), body, null, null
    ' ...and one to the admins
    dispatchNotification "proofingadmins@ij.org", "Proofing Assignment Claimed " & rs("Description"), body, null, null
  end if
%>
<!--#include file="assignments.asp" -->