<!--#include file="authcheck.asp" -->
<!--#include virtual="/lib/notifications.asp" -->
<%
  Set objConn = Application("objConnection")

  '' add in expectedelivery and requestedreturn
  sqlx = "EXEC spCreate '" & replace(request("description"), "'", "''") & "', '" & replace(request("summary"), "'", "''") & "', '" & replace(request("expected_delivery"), "'", "''") & "', '" & replace(request("requested_return"), "'", "''") & "', " & Session("id") & ", '" & replace(request("case"), "'", "''") & "', " & replace(request("program"), "'", "''")
  Set rs = objConn.execute(sqlx)

  if not rs.eof then
    id                      = rs("id")
    description             = rs("description")
    summary                 = rs("summary")
    expected_delivery       = rs("ExpectedDelivery")
    requested_return        = rs("RequestedReturn")
    case_num                = rs("case_num")
    case_name               = rs("case_name")
    program_num             = rs("program_num")
    program_name            = rs("program_name")
    creation_date           = rs("CreationDate")
      created_by_id         = rs("CreatedById")
      created_by_username   = rs("CreatedByUsername")
      created_by_email      = rs("CreatedByEmail")

    if isnull(program_num) then program_num=0
%>
{
    "success": true,
    "id": <%=id%>,
    "description": "<%=replace(description, """", "\""")%>",
    "summary": "<%=replace(summary, """", "\""")%>",
    "expected_delivery": "<%=replace(expected_delivery&"", """", "\""")%>",
    "requested_return": "<%=replace(requested_return&"", """", "\""")%>",
    "creation_date": "<%=creation_date%>",
    "case": {
        "case_num": "<%=replace(case_num&"", """", "\""")%>",
        "case_name": "<%=replace(case_name&"", """", "\""")%>"
    },
    "program": {
        "program_num": <%=program_num%>,
        "program_name": "<%=replace(program_name&"", """", "\""")%>"
    },
    "created_by": {
        "id": <%=created_by_id %>,
        "username": "<%=replace(created_by_username, """", "\""")%>",
        "email": "<%=replace(created_by_email, """", "\""")%>"
    },
    "assigned_to": null,
    "time_to_complete": null
}
<%
    '!TODO Send email to Requester
    '
    ' Template:
    '  To: [Requester]; [Proofing Admins]
    '  From: IJ Proofing Assignment System
    '  Reply to: proofingadmins@ij.org
    '  Subject:Proofing Assignment Submitted [assignment description]
    '  Body:
    '         [First Name of Requester],
    '
    '         Your assignment has been submitted and sent to our group of external proofers.
    '
    '         Assignment: [Assignment Description]
    '         Available for Proofing Date: [Delivery Date]
    '         Due Date: [Due Date]
    '         Status: [Assignment Status]
    '         Summary: [Assignment Summary]
    '
    '         You will receive confirmation once this task has been claimed by a proofer.

    body = Session("firstname") & ",<br /><br />" & _
           "Your assignment has been submitted and sent to our group of external proofers.<br /><br />" & _
           "<strong>Assignment</strong>: " & description & "<br />" & _
           "<strong>Available for Proofing Date</strong>: " & expected_delivery & "<br />" & vbcrlf & _
           "<strong>Due Date</strong>: " & requested_return & "<br />" & vbcrlf & _
           "<strong>Status</strong>: Available<br />" & vbcrlf & _
           "<strong>Summary</strong>: " & summary & "<br /><br />" & _
           "You will receive confirmation once this task has been claimed by a proofer."

    ' One to the creator...
    dispatchNotification Session("Email"), "Proofing Assignment Submitted " & description, body, null, null
    ' ...and one to the admins
    dispatchNotification "proofingadmins@ij.org", "Proofing Assignment Submitted " & description, body, null, null

    '!TODO Send email to External Proofers
    '
    ' Template:
    '         To: [External Proofers]
    '         From: [Requester]
    '         Reply to: [Requester]
    '         Subject: Proofing Assignment Submitted [assignment description]
    '         Body:
    '
    '         A proofing assignment has become available from the Institute for Justice.  To claim this assignment, click here:
    '
    '         [URL to assignment record in web portal]
    '
    '         Assignment: [Assignment Description]
    '         Available for Proofing Date: [Delivery Date]
    '         Due Date: [Due Date]
    '         Summary: [Assignment Summary]

    body = "A proofing assignment has become available from the Institute for Justice.  To claim this assignment, click here:<br /><br />" & _
           "http://proofing.ij.org/#/assignments/" & id & "<br /><br />" & _
           "Assignment: " & description & "<br />" & _
           "Available for Proofing Date: " & expected_delivery & "<br />" & vbcrlf & _
           "Due Date: " & requested_return & "<br />" & vbcrlf & _
           "Summary: " & summary & "<br /><br />"

    sqlx = "SELECT Email from [User] WHERE Administrator=0"
    Set rs = objConn.execute(sqlx)

    while not rs.eof
      dispatchNotification rs("Email"), "Proofing Assignment Submitted " & description, body, created_by_email, created_by_email
      rs.movenext
    wend


   else
%>
{ "success": false }
<% end if %>

