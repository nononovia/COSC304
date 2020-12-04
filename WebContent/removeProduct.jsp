<%@ include file="jdbc.jsp" %>
<%@ include file="auth.jsp" %>
<%
    int productId = Integer.parseInt(request.getParameter("id"));

    // add review to database
    try {
        getConnection();

        String sql = "DELETE FROM product WHERE productId = ?";
        PreparedStatement stmt = con.prepareStatement(sql);
        stmt.setInt(1, productId);
        stmt.executeUpdate();

        closeConnection();

        response.sendRedirect("admin.jsp");

    } catch (SQLException exp) { out.println(exp); }
%>