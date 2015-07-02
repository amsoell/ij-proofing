<!--#include file="authcheck.asp" -->
<%
  Set objConn = Application("objConnection")

  '' add in expectedelivery and requestedreturn
  sqlx = "EXEC spCreate '" & replace(request("description"), "'", "''") & "', '" & replace(request("expected_delivery"), "'", "''") & "', '" & replace(request("requested_return"), "'", "''") & "', " & Session("id")
  Set rs = objConn.execute(sqlx)

  if not rs.eof then
    id                      = rs("id")
    description             = rs("description")
    expected_delivery       = rs("ExpectedDelivery")
    requested_return        = rs("RequestedReturn")
    creation_date           = rs("CreationDate")
      created_by_id         = rs("CreatedById")
      created_by_username   = rs("CreatedByUsername")
      created_by_email      = rs("CreatedByEmail")
%>
{
    "success": true,
    "id": <%=id%>,
    "description": "<%=replace(description, """", "\""")%>",
    "expected_delivery": "<%=replace(expected_delivery&"", """", "\""")%>",
    "requested_return": "<%=replace(requested_return&"", """", "\""")%>",
    "creation_date": "<%=creation_date%>",
    "created_by": {
        "id": <%=created_by_id %>,
        "username": "<%=replace(created_by_username, """", "\""")%>",
        "email": "<%=replace(created_by_email, """", "\""")%>"
    },
    "assigned_to": null,
    "time_to_complete": null
}

<% else %>
{ "success": false }
<% end if %>

