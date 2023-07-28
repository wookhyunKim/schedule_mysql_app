<%@page import="java.sql.*"%>
<%  
    /*
    Date: 2021-12-25
    Notes : Json Module을 이용한 Json 구성
    */
%>
<%@page import="org.json.simple.JSONObject"%>
<%@page import="org.json.simple.JSONArray"%>

<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
	String url_mysql = "jdbc:mysql://localhost/scheduler?serverTimezone=UTC&characterEncoding=utf8&useSSL=FALSE";
 	String id_mysql = "root";
 	String pw_mysql = "qwer1234";
    String WhereDefault = "select dcode, dtitle, dcontent, ddate from Note ";

    // Date : 2021-12-25
    JSONObject jsonList = new JSONObject();
    JSONArray itemList = new JSONArray();
    

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn_mysql = DriverManager.getConnection(url_mysql, id_mysql, pw_mysql);
        Statement stmt_mysql = conn_mysql.createStatement();

        ResultSet rs = stmt_mysql.executeQuery(WhereDefault); 

        while (rs.next()){
            JSONObject tempJson = new JSONObject();
            tempJson.put("code", rs.getString(1));
            tempJson.put("title", rs.getString(2));
            tempJson.put("content", rs.getString(3));
            tempJson.put("date", rs.getString(4));
            itemList.add(tempJson);
        }

        jsonList.put("results",itemList);
        conn_mysql.close();
        out.print(jsonList);

    } catch (Exception e) {
        e.printStackTrace();
    }
%>
