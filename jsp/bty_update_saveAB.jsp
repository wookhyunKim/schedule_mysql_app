<%@page import="java.sql.*"%>
<%@page import="org.json.simple.JSONObject"%>
<%@page import="org.json.simple.JSONArray"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    String url_mysql = "jdbc:mysql://localhost/scheduler?serverTimezone=UTC&characterEncoding=utf8&useSSL=FALSE";
    String id_mysql = "root";
    String pw_mysql = "qwer1234";
    String code = request.getParameter("code");
    String title = request.getParameter("title");
    int amount = Integer.parseInt(request.getParameter("amount"));
    int state = Integer.parseInt(request.getParameter("state"));
    String duedate = request.getParameter("date");
    String content = request.getParameter("content");
    String WhereDefault = "update accountbook set ab_title = ?, ab_content = ?, ab_amount = ?, ab_confirmdate = ?, ab_confirm = ? , ab_insertdate = now() where ab_code = ?";

    JSONObject jsonList = new JSONObject();
    JSONArray itemList = new JSONArray();
    PreparedStatement ps = null;
    ResultSet rs = null; // Declare the ResultSet

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn_mysql = DriverManager.getConnection(url_mysql, id_mysql, pw_mysql);
        Statement stmt_mysql = conn_mysql.createStatement();

        ps = conn_mysql.prepareStatement(WhereDefault);
        ps.setString(1, title); // Set the parameter on the PreparedStatement
        ps.setString(2, content); // Set the parameter on the PreparedStatement
        ps.setInt(3, amount); // Set the parameter on the PreparedStatement
        ps.setString(4, duedate); // Set the parameter on the PreparedStatement
        ps.setInt(5, state); // Set the parameter on the PreparedStatement
        ps.setString(6, code); // Set the parameter on the PreparedStatement

        ps.executeUpdate();
	
        conn_mysql.close();
%>
{"result":"OK"}	
<%			
    } 
    catch (Exception e){
%>		
{"result":"ERROR"}	
<%		
    }
%>
