<%
  Set objConn = Application("objConnection")
  
  sqlx = "EXEC spUpdate " & request("id") & ", '" & replace(request("description"), "'", "''") & "', "
  if isnull(request("restrictto")) then
    sqlx = sqlx & "null"
  else 
    sqlx = sqlx & request("restrictto")
  end if

  Set rs = objConn.execute(sqlx)
  
  if not rs.eof then
    id                  = rs("id")
    description         = rs("description")
    restrictto              = rs("restrictto")
    creation_date       = rs("CreationDate")
    created_by          = rs("CreatedBy")
    created_by_name     = rs("CreatedByName")
    assigned_to         = rs("AssignedTo")
    assigned_to_name    = rs("AssignedToName")
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
<%   if IsNull(rs("AssignedTo")) then  %>
    "assigned_to": null
<%   else  %>
    "assigned_to": {
      "id": <%=assigned_to%>,
      "name": "<%=replace("assigned_to_name", """", "\""")%>"  
    }
<%   end if  %>
}
<% else %>
{ "success": false }
<% end if %>

