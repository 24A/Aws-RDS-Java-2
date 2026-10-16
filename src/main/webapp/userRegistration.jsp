<%@ page import="java.sql.*" %>

<%
    String userName = request.getParameter("userName");
    String password = request.getParameter("password");
    String firstName = request.getParameter("firstName");
    String lastName = request.getParameter("lastName");
    String email = request.getParameter("email");

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
        "INSERT INTO `USER` " +
        "(first_name, last_name, email, username, password, regdate) " +
        "VALUES (?, ?, ?, ?, ?, CURDATE())";

    try (
        Connection con =
            DriverManager.getConnection(dbUrl, dbUser, dbPassword);

        PreparedStatement ps =
            con.prepareStatement(sql)
    ) {
        ps.setString(1, firstName);
        ps.setString(2, lastName);
        ps.setString(3, email);
        ps.setString(4, userName);
        ps.setString(5, password);

        int result = ps.executeUpdate();

        if (result > 0) {
            response.sendRedirect("welcome.jsp");
        } else {
            response.sendRedirect("index.jsp");
        }
    }
%>