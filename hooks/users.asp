<!--#include virtual="/hooks/authcheck.asp" -->
<!--#include virtual="/lib/json.asp" -->
<%
  Set objConn = Application("objConnection_Proofing")

  if request("id")>0 then
    sqlx = "SELECT u.id, u.username, u.firstname + ' ' + u.lastname AS fullname, u.firstname, u.lastname, u.compensation, u.email, u.address, u.phone, ISNULL(Administrator, 0) AS administrator FROM [User] u WHERE u.id=" & request("id")
    Set rs = objConn.execute(sqlx)

    if not rs.eof then
      response.write "{ ""success"": true, ""user"":  "

      id            = rs("id")
      username      = rs("username")
      fullname      = rs("fullname")
      firstname     = rs("firstname")
      lastname      = rs("lastname")
      compensation  = rs("compensation")
      email         = rs("email")
      address       = rs("address")
      phone         = rs("phone")
      administrator = rs("administrator")
%>
    {
        "success": true,
        "id": <%=id%>,
        "username": "<%=escapeJSON(username)%>",
        "fullname": "<%=escapeJSON(fullname)%>",
        "firstname": "<%=escapeJSON(firstname)%>",
        "lastname": "<%=escapeJSON(lastname)%>",
        "email": "<%=escapeJSON(email)%>",
        "compensation": "<%=escapeJSON(compensation)%>",
        "address": "<%=escapeJSON(address)%>",
        "phone": "<%=escapeJSON(phone)%>",
        "administrator": "<%=escapeJSON(cint(administrator))%>"
    }
<%
      response.write " }"
    else
      response.write "{ ""success"": false, ""reason"": ""User not found"" }"
    end if
  else
    sqlx = "SELECT u.id, u.username, u.firstname+' '+u.lastname AS fullname, u.firstname, u.lastname, u.compensation, u.email, u.address, u.phone, ISNULL(u.administrator, 0) AS administrator FROM [User] u"

    Set rs = objConn.execute(sqlx)

    if not rs.eof then
      response.write "{ ""success"": true, ""users"": [ "

      while not rs.eof

        id              = rs("id")
        username        = rs("username")
        fullname        = rs("fullname")
        firstname       = rs("firstname")
        lastname        = rs("lastname")
        compensation    = rs("compensation")
        email           = rs("email")
        address         = rs("address")
        phone           = rs("phone")
        administrator   = rs("administrator")
%>
    {
        "id": <%=id%>,
        "username": "<%=escapeJSON(username)%>",
        "fullname": "<%=escapeJSON(fullname)%>",
        "firstname": "<%=escapeJSON(firstname)%>",
        "lastname": "<%=escapeJSON(lastname)%>",
        "email": "<%=escapeJSON(email)%>",
        "compensation": "<%=escapeJSON(compensation)%>",
        "address": "<%=escapeJSON(address)%>",
        "phone": "<%=escapeJSON(phone)%>",
        "administrator": <%=escapeJSON(cint(administrator))%>
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