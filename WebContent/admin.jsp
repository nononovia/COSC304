<%@ page language="java" import="java.io.*,java.sql.*"%>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ include file="jdbc.jsp" %>

<!-- Checking whether user is logged in -->
<%@ include file="auth.jsp" %>

<!DOCTYPE html>
<html>
    <head>
        <title>Administrator Page</title>
    </head>
    <body style="padding-top: 45px">
        <%@include file="header.jsp"%>
        <div class="container mt-5">
            <h2 class="mb-3"><strong>Administrator Settings</strong></h2>

            <%
                try {
                    // Setup connection
                    getConnection();

                    // User Id for getting order data
                    String userid = (String)session.getAttribute("authenticatedUser");
                    NumberFormat currFormat = NumberFormat.getCurrencyInstance(new Locale("en","US"));

                    // tabs
                    out.println(
                        "<ul class='nav nav-tabs'>" +
                            "<li style='cursor:pointer' class='nav-item'>" +
                            "<a class='nav-link tab-nav active' onclick=openTab(event,'orderInfo') id='originalOpen' checked>Order Info</a>" +
                            "</li>" +
                            "<li style='cursor:pointer' class='nav-item ml-2'>" +
                            "<a class='nav-link tab-nav' onclick=openTab(event,'customers')>Customers</a>" +
                            "</li>" +
                            "<li style='cursor:pointer' class='nav-item ml-2'>" +
                            "<a class='nav-link tab-nav' onclick=openTab(event,'products')>Products</a>" +
                            "</li>" +
                        "</ul>"
                    );

                    out.println("<div id='orderInfo' class='tabDetails mt-3'>");
                    out.println("<h3 class='mb-2'>Administrator sales report by day</h3>");
                    // Write SQL query that prints out total order amount by day
                    String sql = "SELECT max(orderDate), max(totalAmount) FROM ordersummary GROUP BY YEAR(orderDate), MONTH(orderDate), DAY(orderDate)";
                    // Create SQL statement with userid
                    PreparedStatement pstmt = con.prepareStatement(sql);
                    ResultSet rst = pstmt.executeQuery();
                    // Start drawing table data
                    out.println("<table class='table table-striped'><thead class='thead-dark'><tr><td>Order Date</td><td>Total Order Amount</td></tr></thead>");
                    while(rst.next()) {
                        // Each row shows order date and total order amount from results
                        out.println("<tr><td>" + rst.getDate(1) + "</td><td>" + currFormat.format(rst.getDouble(2)) + "</td></tr>");
                    }
                    out.println("</table>");
                    out.println("</div>");


                    out.println("<div id='customers' class='tabDetails mt-3'>");
                    // Add new product
                    out.println("<form method='post' action='addCustomer.jsp?' class='bg-light p-4 rounded'>" +
                                    "<h5>Add a customer:</h5>" +
                                    "<input type='text' class='form-control form-control-sm mt-2' name='fn' placeholder='First Name'>" +
                                    "<input type='text' class='form-control form-control-sm mt-2' name='ln' placeholder='Last Name'>" +
                                    "<input type='text' class='form-control form-control-sm mt-2' name='em' placeholder='email'>" +
                                    "<input type='text' class='form-control form-control-sm mt-2' name='pn' placeholder='Phone Number'>" +
                                    "<input type='text' class='form-control form-control-sm mt-2' name='ad' placeholder='Address'>" +
                                    "<input type='text' class='form-control form-control-sm mt-2' name='ci' placeholder='City'>" +
                                    "<input type='text' class='form-control form-control-sm mt-2' name='st' placeholder='State'>" +
                                    "<input type='text' class='form-control form-control-sm mt-2' name='pc' placeholder='Postal Code'>" +
                                    "<input type='text' class='form-control form-control-sm mt-2' name='co' placeholder='Country'>" +
                                    "<input type='text' class='form-control form-control-sm mt-2' name='id' placeholder='User ID'>" +
                                    "<input type='password' class='form-control form-control-sm mt-2' name='ps' placeholder='User Password'>" +
                                    "<div class='text-right'><button type='submit' class='btn btn-warning mt-3'>Add Customer</button></div>" +
                                "</form>");
                    // Get customer data
                    sql = "SELECT * FROM customer ORDER BY customerId DESC";
                    pstmt = con.prepareStatement(sql);
                    rst = pstmt.executeQuery();
                    while (rst.next()) {
                        out.println("<div class='bg-light p-4 mt-3 mb-3 rounded'>");
                        out.println("<address>" +
                                    "<strong>"+rst.getString(2)+" "+rst.getString(3)+"</strong><br>" +
                                    ""+rst.getString(6)+"<br>" +
                                    ""+rst.getString(7)+", "+rst.getString(8)+" "+rst.getString(9)+"<br>" +
                                    ""+rst.getString(10)+"<br>" +
                                    "P: "+rst.getString(5)+"<br><br>" +
                                    ""+rst.getString(4)+"<br>"
                                    );
                        out.println("</div>");
                    }
                    out.println("</div>");
                    

                    out.println("<div id='products' class='tabDetails mt-3'>");
                    // Add new product
                    out.println("<form method='post' action='addProduct.jsp?' class='bg-light p-4 rounded'>" +
                                    "<h5>Add a product:</h5>" +
                                    "<input type='text' class='form-control form-control-sm mt-2' name='pr' placeholder='Price'>" +
                                    "<input type='text' class='form-control form-control-sm mt-2' name='url' placeholder='Image URL'>" +
                                    "<input type='text' class='form-control form-control-sm mt-2' name='br' placeholder='Brand'>" +
                                    "<input type='text' class='form-control form-control-sm mt-2' name='evt' placeholder='EV Type'>" +
                                    "<input type='text' class='form-control form-control-sm mt-2' name='bid' placeholder='Brand Id'>" +
                                    "<input type='text' class='form-control form-control-sm mt-2' name='m' placeholder='Model'>" +
                                    "<input type='text' class='form-control form-control-sm mt-2' name='ry' placeholder='Release Year'>" +
                                    "<input type='text' class='form-control form-control-sm mt-2' name='v' placeholder='Variant'>" +
                                    "<input type='text' class='form-control form-control-sm mt-2' name='bs' placeholder='Battery Size'>" +
                                    "<h4>...</h4>" +
                                    "<div class='text-right'><button type='submit' class='btn btn-warning mt-3'>Add Product</button></div>" +
                                "</form>");
                    
                    // Get product columns
                    sql = "SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = N'product'";
                    pstmt = con.prepareStatement(sql);
                    rst = pstmt.executeQuery();
                    List<String> tableNames = new ArrayList<>();
                    while (rst.next()) {
                        tableNames.add(rst.getString(1));
                    }
                    // Get product data
                    sql = "SELECT * FROM product ORDER BY productId DESC";
                    pstmt = con.prepareStatement(sql);
                    rst = pstmt.executeQuery();
                    out.println("<div class='table-responsive mt-3'>");
                    out.println("<h4 class='ml-4'>Products:</h4>");
                    out.println("<table class='table table-striped'><thead class='thead-dark'><tr>");
                    out.println("<td></td>");
                    for(int i = 1; i < tableNames.size(); i++) {
                        out.println("<td>"+tableNames.get(i-1)+"</td>");
                    }
                    out.println("</tr></thead>");
                    while (rst.next()) {
                        out.println("<tr>");
                        out.println("<td><a class='btn btn-danger' href='removeProduct.jsp?id="+rst.getString(1)+"'>Delete</a></td>");
                        for(int i = 1; i < tableNames.size(); i++) {
                            out.println("<td>"+rst.getString(i)+"</td>");
                        }
                        out.println("</tr>");
                    }
                    out.println("</table>");
                    out.println("</div>");

                    out.println("<div class='text-right'><a class='btn btn-sm btn-danger' href='loaddata.jsp'><strong>Restore Database</strong></a></div>");

                    out.println("</div>");
                    out.println("<div class='mb-5'></div>");


                    // Close connection
                    closeConnection();
                } catch(SQLException ex) {
                    out.println(ex);
                }
            %>
        </div>

    </body>
    <script>
        document.getElementById("originalOpen").click();
    
        function openTab(evt, tab) {
            var i, tabs, tabNavs;
    
            tabs = document.getElementsByClassName("tabDetails");
            for (i = 0; i < tabs.length; i++)
                tabs[i].style.display = "none";
    
            tabNavs = document.getElementsByClassName("tab-nav");
            for (i = 0; i < tabNavs.length; i++)
                tabNavs[i].className = tabNavs[i].className.replace(" active", "");
    
            clickTab = document.getElementById(tab);
            clickTab.style.display = "block";
            evt.currentTarget.className += " active";
        }
    </script>
</html>

