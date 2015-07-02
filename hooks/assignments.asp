<!--#include file="authcheck.asp" -->
<%
  Set objConn = Application("objConnection")

  if request("id")>0 then
    '! One assignment
    sqlx = "SELECT t.id, t.Description, t.Summary, t.ExpectedDelivery, t.RequestedReturn, t.CreationDate, t.CreatedBy AS CreatedById, c.Firstname + ' ' + c.Lastname AS CreatedByFullname, c.Email as CreatedByEmail, t.AssignedTo AS AssignedToId, a.Username AS AssignedToUsername, ISNULL(a.Firstname,'') + ' ' + ISNULL(a.Lastname,'') AS AssignedToFullname, a.Email AS AssignedToEmail, t.CompletionDate, t.TimeToComplete FROM Task t LEFT JOIN [User] c ON t.CreatedBy=c.id LEFT JOIN [User] a ON t.AssignedTo=a.id WHERE t.id=" & request("id")
    Set rs = objConn.execute(sqlx)

    if not rs.eof then
      response.write "{ ""success"": true, ""assignment"":  "

      id                        = rs("id")
      description               = rs("description")
      summary                   = rs("summary")
      expected_delivery         = rs("ExpectedDelivery")
      requested_return          = rs("RequestedReturn")
      creation_date             = rs("CreationDate")
      created_by_id             = rs("CreatedById")
        created_by_email        = rs("CreatedByEmail")
        created_by_fullname     = rs("CreatedByFullname")

      assigned_to_id            = rs("AssignedToId")
      if not IsNull(assigned_to_id) then
        assigned_to_email       = rs("AssignedToEmail")
        assigned_to_name        = rs("AssignedToUsername")
        assigned_to_fullname    = rs("AssignedToFullname")
      end if
      completion_date           = rs("CompletionDate")
      time_to_complete          = rs("TimeToComplete")
%>
    {
        "success": true,
        "id": <%=id%>,
        "description": "<%=replace(description&"", """", "\""")%>",
        "summary": "<%=replace(summary&"", """", "\""")%>",
        "expected_delivery": "<%=replace(expected_delivery&"", """", "\""")%>",
        "requested_return": "<%=replace(requested_return&"", """", "\""")%>",
        "creation_date": "<%=creation_date%>",
        "created_by": {
          "id": <%=created_by_id%>,
          "fullname": "<%=replace(created_by_fullname&"", """", "\""")%>",
          "email": "<%=replace(created_by_email&"", """", "\""")%>"
        },
<%   if IsNull(assigned_to_id) then  %>
        "assigned_to": null,
<%   else  %>
        "assigned_to": {
          "id": <%=assigned_to_id%>,
          "username": "<%=replace(assigned_to_username&"", """", "\""")%>",
          "fullname": "<%=replace(assigned_to_fullname&"", """", "\""")%>",
          "email": "<%=replace(assigned_to_email&"", """", "\""")%>"
        },
<%   end if  %>
<%   if IsNull(completion_date) then %>
        "completion_date": null,
<%   else %>
        "completion_date": "<%=completion_date%>",
<%   end if %>
<%   if IsNull(time_to_complete) then %>
        "time_to_complete": null
<%   else %>
        "time_to_complete": <%=time_to_complete%>
<%   end if %>
    }
<%
      response.write " }"
    else
      response.write "{ ""success"": false }"
    end if
  else
    '! All assignments
    sqlx = "SELECT t.id, t.Description, t.Summary, t.ExpectedDelivery, t.RequestedReturn, CONVERT(varchar(50), t.CreationDate, 127) AS CreationDate, t.CreatedBy AS CreatedById, c.FirstName + ' ' + c.LastName AS CreatedByFullname, c.Email as CreatedByEmail, t.AssignedTo AS AssignedToId, a.Username AS AssignedToUsername, ISNULL(a.Firstname,'')+' '+ISNULL(a.Lastname,'') AS AssignedToFullname, a.Email AS AssignedToEmail, t.CompletionDate, t.TimeToComplete FROM Task t LEFT JOIN [User] c ON t.CreatedBy=c.id LEFT JOIN [User] a ON t.AssignedTo=a.id ORDER BY t.id DESC"

    Set rs = objConn.execute(sqlx)

    if true then 'not rs.eof then
      response.write "{ ""success"": true, ""assignments"": [ "
      while not rs.eof
        id                  = rs("id")
        description         = rs("description")
        summary             = rs("summary")
        expected_delivery   = rs("ExpectedDelivery")
        requested_return    = rs("RequestedReturn")
        creation_date       = rs("CreationDate")
        created_by_id             = rs("CreatedById")
          created_by_email        = rs("CreatedByEmail")
          created_by_fullname     = rs("CreatedByFullname")

        assigned_to_id            = rs("AssignedToId")
        if not IsNull(assigned_to_id) then
          assigned_to_email       = rs("AssignedToEmail")
          assigned_to_name        = rs("AssignedToUsername")
          assigned_to_fullname    = rs("AssignedToFullname")
        end if
        completion_date     = rs("CompletionDate")
        time_to_complete    = rs("TimeToComplete")

        if isnull(assigned_to_id) then
          status = "Available"
        elseif isnull(completion_date) then
          status = "Claimed"
        else
          status = "Completed"
        end if
%>
    {
        "id": <%=id%>,
        "description": "<%=replace(description, """", "\""")%>",
        "summary": "<%=replace(summary&"", """", "\""")%>",
        "expected_delivery": "<%=replace(expected_delivery&"", """", "\""")%>",
        "requested_return": "<%=replace(requested_return&"", """", "\""")%>",
        "creation_date": "<%=creation_date%>",
        "created_by": {
          "id": <%=created_by_id%>,
          "fullname": "<%=replace(created_by_fullname&"", """", "\""")%>",
          "email": "<%=replace(created_by_email&"", """", "\""")%>"
        },
<%   if IsNull(assigned_to_id) then  %>
        "assigned_to": null,
<%   else  %>
        "assigned_to": {
          "id": <%=assigned_to_id%>,
          "username": "<%=replace(assigned_to_username&"", """", "\""")%>",
          "fullname": "<%=replace(assigned_to_fullname&"", """", "\""")%>",
          "email": "<%=replace(assigned_to_email&"", """", "\""")%>"
        },
<%   end if  %>
        "status": "<%=status%>",
<%   if IsNull(completion_date) then %>
        "completion_date": null,
<%   else %>
        "completion_date": "<%=completion_date%>",
<%   end if %>
<%   if IsNull(time_to_complete) then %>
        "time_to_complete": null
<%   else %>
        "time_to_complete": <%=time_to_complete%>
<%   end if %>
    }
<%
        rs.movenext
        if not rs.eof then response.write ","
      wend
      response.write " ] }"
    else
%>
  { "success": false }
<%
    end if
  end if
%>