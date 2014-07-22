<!--#include file="../lib/sha256.asp"-->
<%
  Set objConn = Application("objConnection")
  
  if len(Session("isAuthenticated"))<=0 then
    if len(request("username"))>0 and len(request("password"))>0 then
      username = request("username")
      password = request("password")
    else 
      username = "notsupplied"
    end if
    
    sqlx = "SELECT TOP (1) id, Email, Username, Fullname, Administrator FROM [User] WHERE Username='" & replace(username, "'", "''") & "' AND Password='" & sha256(password) & "'"

    Set rs = objConn.execute(sqlx)
    
    if rs.eof then
%>
{ "authenticated": false, "reasonCode": 1, "reason": "Username or password not valid" }
<%
      response.end
    else
      id            = rs("id")
      username      = rs("Username")
      email_address = rs("Email")
      fullname      = rs("Fullname")
      if rs("Administrator")>0 then
        administrator = "true"
        Session("isAdministrator") = true
      else  
        administrator = "false"
        Session("isAdministrator") = false
      end if
%>
{ 
  "authenticated": true,
  "user": {
    "id": <%=id%>,
    "username": "<%=username%>",
    "email": "<%=email_address%>",
    "fullname": "<%=fullname%>",
    "administrator": <%=administrator%>,
    "authenticated": true
  }
}
<%      
      Session("id")                 = id
      Session("username")           = username
      Session("email")              = email_address
      Session("fullname")           = fullname
      
      Session("isAuthenticated")    = 1
    end if
  else 
%>
{ 
  "authenticated": true,
  "user": {
    "username": "<%=Session("Email")%>",
    "authenticated": true
  }
}
<%
  end if
%>