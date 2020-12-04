<%@ page import="java.util.HashMap" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="jdbc.jsp" %>
<%@ page import="java.util.Locale" %>

<html>
<head>
<title>Rays Grocery - Product Information</title>
<link href="css/bootstrap.min.css" rel="stylesheet">
</head>
<body style="padding-top: 45px">

<%@ include file="header.jsp" %>

<div class="container mt-5">
<%
// Get product name to search for
// TODO: Retrieve and display info for the product
String productId = request.getParameter("id");

String url = "jdbc:sqlserver://db:1433;DatabaseName=tempdb;";
String uid = "SA";
String pw = "YourStrong@Passw0rd";

try {
    getConnection();

    String sql = "SELECT productBrand, productModel, productReleaseYear, productImageURL, productId, productPrice FROM product WHERE productId =? ";
    PreparedStatement stmt=con.prepareStatement(sql);
    stmt.setInt(1,Integer.parseInt(productId));
    ResultSet rst = stmt.executeQuery();
    NumberFormat currFormat = NumberFormat.getCurrencyInstance(new Locale("en","US"));

    while(rst.next()){
        out.println("<h1>"+rst.getString(1)+" "+rst.getString(2)+"</h1>");
        if(rst.getString(4)!=null)
        out.println("<img src="+rst.getString(4)+">");
        out.println("<img src=displayImage.jsp?id="+rst.getInt(5)+">");
        out.println("<h4>ID: "+rst.getInt(5)+"</h4><h4>Price: "+currFormat.format(rst.getDouble(6))+"</h4>");
        out.println(
            "<div class='mt-3'>"+
                "<button class=btn btn-light m-3><a href=addcart.jsp?id="+rst.getInt(5)+"&brand="+rst.getString(1)+"&model="+rst.getString(2).replaceAll(" ","+")+
                    "&price="+rst.getDouble(6)+">Add To Cart</a></button>"+"<button class='btn btn-light m-3'><a href='listprod.jsp'>Continue Shopping</a></button>"+
            "</div>");
    }

    closeConnection();


} catch (SQLException ex) { out.println(ex); }
%>
</div>

</body>
</html>

