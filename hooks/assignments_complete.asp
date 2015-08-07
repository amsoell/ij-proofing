<!--#include file="authcheck.asp" -->
<!--#include virtual="/lib/notifications.asp" -->
<%
  Set dbProofing = Application("objConnection_Proofing")

  if IsNumeric(request("time_to_complete")) then
    sqlx = "UPDATE Task SET "
    sqlx = sqlx & "TimeToComplete=" & request("time_to_complete") & ", "
    sqlx = sqlx & "CompletionDate=CURRENT_TIMESTAMP, "
    sqlx = sqlx & "CreationDate=CreationDate WHERE id=" & request("id") & " AND AssignedTo IS NOT NULL AND AssignedTo=" & Session("id")
    dbProofing.execute(sqlx)

    '! Send notification

    sqlx = "SELECT t.CreatedByEmail AS Email, t.Description, t.ExpectedDelivery, t.RequestedReturn, t.Summary, t.[Case] AS case_num, t.Program AS program_num, a.FirstName + ' ' + a.LastName AS Fullname, a.Email AS assigned_email, a.Phone AS assigned_phone, t.TimeToComplete, a.Compensation, a.Address as assigned_address FROM Task t " & _
           "INNER JOIN [User] a ON t.AssignedTo=a.id " & _
           "WHERE t.id=" & request("id")
    Set rs = dbProofing.execute(sqlx)

    if not rs.eof then
      assigned_address  = rs("assigned_address")
      email             = rs("Email")
      fullname          = rs("fullname")
      description       = rs("description")
      expected_delivery = rs("ExpectedDelivery")
      requested_return  = rs("RequestedReturn")
      summary           = rs("summary")
      case_num          = rs("case_num")
      program_num       = rs("program_num")
      time_to_complete  = rs("TimeToComplete")
      compensation      = rs("Compensation")
      assigned_email    = rs("assigned_email")
      assigned_phone    = rs("assigned_phone")

      '! - To the creator...
      ' Template
      '  To: Requester; Proofing Admins
      '  From: IJ Proofing Assignment System
      '  Reply to: Requester; Proofing Admins
      '  Subject: Proofing Assignment Completed[assignment description]
      '  Body:
      '
      '         [First Name of Requester],
      '
      '         Your assignment has been completed by [proofer first name, proofer last name].
      '
      '         Assignment: [Assignment Description]
      '         Available for Proofing Date: [Delivery Date]
      '         Due Date: [Due Date]
      '         Summary: [Assignment Summary]
      '         --------------------------------------------------------------------------------------

      body = "Your assignment has been completed by <strong>" & fullname & "</strong><br /><br />" & _
             "<strong>Assignment</strong>: " & description & "<br />" & _
             "<strong>Available for Proofing Date</strong>: " & expected_delivery & "<br />" & vbcrlf & _
             "<strong>Due Date</strong>: " & requested_return & "<br />" & vbcrlf & _
             "<strong>Summary</strong>: " & summary

      ' One to the creator...
      dispatchNotification email, "Proofing Assignment Completed: " & description, body, null, null
      ' ...and one to the admins
      dispatchNotification "proofingadmins@ij.org", "Proofing Assignment Completed: " & description, body, null, null

      '! - ...and to accounting
      ' Template
      '  To: Accounting
      '  From: IJ Proofing Assignment System
      '  Reply to: Requester; Proofing Admins
      '  Subject: Proofing Assignment Invoice #[assignment record ID] for [assignment description]
      '  Body:
      '
      '         Please pay [proofer first name, proofer last name] for completing the following proofing assignment:
      '
      '         Invoice Number: [assignment record ID]
      '         Assignment: [Assignment Description]
      '         Case Code & Program: [Case/ Program]
      '         Hours:[Assignment Hours]
      '         Rate:[User Rate]
      '         Total: $[UserRate multiplied by Hours]
      '
      '         Please mail check to:
      '         [Mailing Address]
      '         [Email Address]
      '         [Telephone]
      '
      '         --------------------------------------------------------------------------------------
      body = "Please pay <strong>" & fullname & "</strong> for completing the following proofing assignment:<br /><br />" & vbcrlf & vbcrlf & _
             "<strong>Invoice Number</strong>: " & request("id") & "<br />" & vbcrlf &  _
             "<strong>Assignment</strong>: " & description & "<br />" & vbcrlf & _
             "<strong>Case Code & Program</strong>: " & case_num & " / " & program_num & "<br />" & vbcrlf & _
             "<strong>Hours</strong>: " & time_to_complete & "<br />" & vbcrlf & _
             "<strong>Rate</strong>: " & compensation & "<br />" & vbcrlf
      if IsNumeric(time_to_complete) and IsNumeric(compensation) then
        invoiceTotal = time_to_complete * compensation
        body = body & "<strong>Total</strong>: " & FormatCurrency(invoiceTotal) & "<br />" & vbcrlf
      end if

      body = body & vbcrlf & "<br />" & _
             "Please mail check to: <br />" & vbcrlf & _
             assigned_address & "<br />" & vbcrlf & _
             assigned_email & "<br />" & vbcrlf & _
             assigned_phone & "<br />"

      dispatchNotification "accounting@ij.org", "Proofing Assignment Invoice #" & request("id") & " for " & rs("Description"), body, null, null
  end if


  else
    response.write "{ ""success"": false }"
    response.end
  end if
%>
<!--#include file="assignments.asp" -->