<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>        
<%
	request.setCharacterEncoding("utf-8");
	String code = request.getParameter("code");
	String title = request.getParameter("title");
	String content = request.getParameter("content");
	String date = request.getParameter("date");	
		
//------
	String url_mysql = "jdbc:mysql://localhost/scheduler?serverTimezone=UTC&characterEncoding=utf8&useSSL=FALSE";
	String id_mysql = "root";
	String pw_mysql = "qwer1234";

	PreparedStatement ps = null;
	try{
	    Class.forName("com.mysql.cj.jdbc.Driver");
	    Connection conn_mysql = DriverManager.getConnection(url_mysql,id_mysql,pw_mysql);
	    Statement stmt_mysql = conn_mysql.createStatement();
	
		String A = "update Note set dtitle = ?, dcontent = ?, ddate = ? ";
		String B = "where dcode = ?";
	
	    ps = conn_mysql.prepareStatement(A+B);
	    ps.setString(1, title);
	    ps.setString(2, content);
	    ps.setString(3, date);
		ps.setString(4, code);

	    
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

