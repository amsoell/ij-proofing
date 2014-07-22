<!--#include file="authcheck.asp" -->
<%
  Set objConn = Application("objConnection")

  if request("id")>0 then 
    sqlx = "SELECT u.id, u.username, u.fullname, u.email FROM [User] u WHERE u.id=" & request("id")
    Set rs = objConn.execute(sqlx)
    
    if not rs.eof then 
      response.write "{ ""success"": true, ""user"":  "

      id        = rs("id")
      username  = rs("username")
      fullname  = rs("fullname")
      email     = rs("email")
%>
    {
        "success": true,
        "id": <%=id%>,
        "username": "<%=replace(username, """", "\""")%>",
        "fullname": "<%=replace(fullname&"", """", "\""")%>",
        "email": "<%=replace(email&"", """", "\""")%>"
    }
<%
      response.write " }"
    else
      response.write "{ ""success"": false, ""reason"": ""User not found"" }"
    end if
  else 
    sqlx = "SELECT u.id, u.username, u.fullname, u.email FROM [User] u"

    Set rs = objConn.execute(sqlx)
    
    if not rs.eof then 
      response.write "{ ""success"": true, ""users"": [ "

      while not rs.eof
      
        id        = rs("id")
        username  = rs("username")
        fullname  = rs("fullname")
        email     = rs("email")
%>
    {
        "id": <%=id%>,
        "username": "<%=replace(username, """", "\""")%>",
        "fullname": "<%=replace(fullname&"", """", "\""")%>",
        "email": "<%=replace(email&"", """", "\""")%>"
    }
<%
        rs.movenext
        if not rs.eof then response.write ","
      wend
      response.write " ] }"
    else
%>
  { "success": false, "reason": "No users found" }
<%
    end if
  end if
%>