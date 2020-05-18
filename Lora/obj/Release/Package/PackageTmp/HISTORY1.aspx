<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="HISTORY1.aspx.cs" Inherits="Lora.HISTORY1" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div style="font-size:50px;">
            <asp:ImageButton ID="ImageButton1" runat="server" OnClick="ImageButton1_Click" ImageUrl="images/yee.jpg" Width="300px" />
            <br />
            <br />
            <asp:Button ID="Button1" runat="server" OnClick="Button1_Click" Text="回上一頁" />
        </div>
    </form>
</body>
</html>
