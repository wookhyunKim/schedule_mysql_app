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
	
	    String A = "insert into Note (dcode, dtitle, dcontent, ddate";
	    String B = ") values (?,?,?,?)";
	
	    ps = conn_mysql.prepareStatement(A+B);
	    ps.setString(1, code);
	    ps.setString(2, title);
	    ps.setString(3, content);
	    ps.setString(4, date);
	    
	    ps.executeUpdate();
	
	    conn_mysql.close();
	} 
	
	catch (Exception e){
	    e.printStackTrace();
	}
%>

