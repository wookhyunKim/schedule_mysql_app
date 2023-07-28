<%@page import="java.sql.*"%>
<%  
    /*
    Date: 2021-12-25
    Notes : Json Module을 이용한 Json 구성
    */
%>
<%@page import="org.json.simple.JSONObject"%>
<%@page import="org.json.simple.JSONArray"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    String url_mysql = "jdbc:mysql://localhost/scheduler?serverTimezone=UTC&characterEncoding=utf8&useSSL=FALSE";
    String id_mysql = "root";
    String pw_mysql = "qwer1234";
    String code = request.getParameter("code");
    String WhereDefault = "select * from accountbook where ab_code = ?";

    JSONObject jsonList = new JSONObject();
    JSONArray itemList = new JSONArray();
    PreparedStatement ps = null;
    ResultSet rs = null; // Declare the ResultSet

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn_mysql = DriverManager.getConnection(url_mysql, id_mysql, pw_mysql);
        Statement stmt_mysql = conn_mysql.createStatement();

        ps = conn_mysql.prepareStatement(WhereDefault);
        ps.setString(1, code); // Set the parameter on the PreparedStatement

        rs = ps.executeQuery(); // Execute the query

        while (rs.next()){
            JSONObject tempJson = new JSONObject();
            tempJson.put("code", rs.getString(1));
            tempJson.put("id", rs.getString(2));
            tempJson.put("title", rs.getString(3));
            tempJson.put("content", rs.getString(4));
            tempJson.put("amount", rs.getString(5));
            tempJson.put("confirmdate", rs.getString(6));
            tempJson.put("confirm", rs.getString(7));
            tempJson.put("in_update", rs.getString(8)); // Correct the key name

            itemList.add(tempJson);
        }

        jsonList.put("abList", itemList);
        conn_mysql.close();
        out.print(jsonList);

    } catch (Exception e) {
        e.printStackTrace();
    }
%>