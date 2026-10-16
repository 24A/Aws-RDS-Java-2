<%@ page import="java.sql.*" %>

<%
    String userName = request.getParameter("userName");
    String password = request.getParameter("password");

    String dbHost = "__DB_HOST__";
    String dbPort = "__DB_PORT__";
    String dbName = "__DB_NAME__";
    String dbUser = "__DB_USER__";
    String dbPassword = "__DB_PASSWORD__";

    String dbUrl =
        "jdbc:mysql://" + dbHost + ":" + dbPort + "/" + dbName +
        "?sslMode=REQUIRED&serverTimezone=UTC";

    Class.forName("com.mysql.cj.jdbc.Driver");

    String sql =
        "SELECT 1 FROM `USER` WHERE username = ? AND password = ?";

    try (
        Connection con =
            DriverManager.getConnection(dbUrl, dbUser, dbPassword);

        PreparedStatement ps =
            con.prepareStatement(sql)
    ) {
        ps.setString(1, userName);
        ps.setString(2, password);

        try (ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                session.setAttribute("userName", userName);
                response.sendRedirect("success.jsp");
            } else {
                out.println(
                    "Invalid password <a href='index.jsp'>try again</a>"
                );
            }
        }
    }
%>