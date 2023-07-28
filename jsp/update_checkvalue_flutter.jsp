<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>        
<%
	request.setCharacterEncoding("utf-8");
	int seq = Integer.parseInt(request.getParameter("seq"));
	String listname = request.getParameter("listname");
	int checkvalue = Integer.parseInt(request.getParameter("checkvalue"));
		
//------
	String url_mysql = "jdbc:mysql://localhost/scheduler?serverTimezone=UTC&characterEncoding=utf8&useSSL=FALSE";
	String id_mysql = "root";
	String pw_mysql = "qwer1234";

	PreparedStatement ps = null;
	try{
	    Class.forName("com.mysql.cj.jdbc.Driver");
	    Connection conn_mysql = DriverManager.getConnection(url_mysql,id_mysql,pw_mysql);
	    Statement stmt_mysql = conn_mysql.createStatement();
	
		String A = "update listTodo set checkvalue = ?, listname = ?, donedate = now()";
		String B = "where seq = ?";
	
	    ps = conn_mysql.prepareStatement(A+B);
	    ps.setInt(1, checkvalue);
	    ps.setString(2, listname);
	    ps.setInt(3, seq);

	    
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

