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
    String id_mysql="root";
    String pw_mysql = "qwer1234";
    int code =Integer.parseInt(request.getParameter("code"));
    String WhereDefault = "delete from accountbook where ab_code = ?";


    PreparedStatement ps = null;
    

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn_mysql = DriverManager.getConnection(url_mysql, id_mysql, pw_mysql);
        Statement stmt_mysql = conn_mysql.createStatement();

        ps = conn_mysql.prepareStatement(WhereDefault);
        ps.setInt(1, code);          // Set the parameter on the PreparedStatement

        ps.executeUpdate();            // Execute the query


        conn_mysql.close();
        
        %>
        {"result":"OK"}	
        <%			
            } 
            catch (Exception e){
        %>	
	
        {"result":"ERROR ${code}"}	
        <%		
            }
        %>

