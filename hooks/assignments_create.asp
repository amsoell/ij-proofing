<%
  Set objConn = Application("objConnection")
  
  sqlx = "EXEC spCreate '" & replace(request("description"), "'", "''") & "', 1"
  Set rs = objConn.execute(sqlx)
  
  if not rs.eof then
    description     = rs("description")
    restrictto          = rs("restrictto")
    id              = rs("id")
    creation_date   = rs("CreationDate")
    created_by      = rs("CreatedBy")
    created_by_name = rs("CreatedByName")
%>
{
    "success": true,
    "id": <%=id%>,
    "description": "<%=replace(description, """", "\""")%>",
    "restrictto": <%=restrictto%>,
    "creation_date": "<%=creation_date%>",
    "created_by": {
        "id": <%=created_by%>,
        "name": "<%=replace(created_by_name, """", "\""")%>"
    },
    "assigned_to": null
}
<% else %>
{ "success": false }
<% end if %>

