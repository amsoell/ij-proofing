<%
  Set objConn = Application("objConnection")

  if request("id")>0 then 
    sqlx = "SELECT t.id, t.Description, t.RestrictTo, t.CreationDate, t.CreatedBy, c.Username AS CreatedByName, t.AssignedTo, a.Username AS AssignedToName FROM Task t LEFT JOIN Users c ON t.CreatedBy=c.id LEFT JOIN Users a ON t.AssignedTo=a.id WHERE t.id=" & request("id")
    Set rs = objConn.execute(sqlx)
    
    if not rs.eof then 
      response.write "{ ""success"": true, ""assignment"":  "
      description = rs("description")
      restrictto = rs("RestrictTo")
      id = rs("id")

      creation_date = rs("CreationDate")
      created_by = rs("CreatedBy")
      created_by_name = rs("CreatedByName")
      assigned_to = rs("AssignedTo")
      assigned_to_name = rs("AssignedToName")
%>
    {
        "id": <%=id%>,
        "description": "<%=replace(description, """", "\""")%>",
<%  if IsNull(restrictto) then %>
        "restrictto": null,
<%  else  %>
        "restrictto": <%=restrictto%>,
<%  end if %>
        "creation_date": "<%=creation_date%>",
        "created_by": {
            "id": <%=created_by%>,
            "name": "<%=replace(created_by_name, """", "\""")%>"
        },
<%   if IsNull(assigned_to) then  %>
        "assigned_to": null
<%   else  %>
        "assigned_to": {
          "id": <%=assigned_to%>,
          "name": "<%=replace("assigned_to_name", """", "\""")%>"  
        }
<%   end if  %>
    }
<%
      response.write " }"
    else
      response.write "{ ""success"": false }"
    end if
  else 
    sqlx = "SELECT t.id, t.Description, t.RestrictTo, t.CreationDate, t.CreatedBy, c.Username AS CreatedByName, t.AssignedTo, a.Username AS AssignedToName FROM Task t LEFT JOIN Users c ON t.CreatedBy=c.id LEFT JOIN Users a ON t.AssignedTo=a.id "
    Set rs = objConn.execute(sqlx)
    
    if not rs.eof then 
      response.write "{ ""success"": true, ""assignments"": [ "
      while not rs.eof
        description = rs("description")
        restrictto = rs("RestrictTo")
        id = rs("id")

        creation_date = rs("CreationDate")
        created_by = rs("CreatedBy")
        created_by_name = rs("CreatedByName")
        assigned_to = rs("AssignedTo")
        assigned_to_name = rs("AssignedToName")
%>
    {
        "id": <%=id%>,
        "description": "<%=replace(description, """", "\""")%>",
<%      if IsNull(restrictto) then %>
        "restrictto": null,
<%      else  %>
        "restrictto": <%=restrictto%>,
<%      end if %>

        "creation_date": "<%=creation_date%>",
        "created_by": {
            "id": <%=created_by%>,
            "name": "<%=replace(created_by_name, """", "\""")%>"
        },
<%   if IsNull(assigned_to) then  %>
        "assigned_to": null
<%   else  %>
        "assigned_to": {
          "id": <%=assigned_to%>,
          "name": "<%=replace("assigned_to_name", """", "\""")%>"  
        }
<%   end if  %>
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