<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>        
<%
	request.setCharacterEncoding("utf-8");
	String uid = request.getParameter("uid");
	String upassword = request.getParameter("upassword");
	String uname = request.getParameter("uname");
	int ugender = Integer.parseInt(request.getParameter("ugender"));
	String uemail = request.getParameter("uemail");
	String uphone = request.getParameter("uphone");
		
//------
	String url_mysql = "jdbc:mysql://localhost/scheduler?serverTimezone=UTC&characterEncoding=utf8&useSSL=FALSE";
	String id_mysql = "root";
	String pw_mysql = "qwer1234";

	PreparedStatement ps = null;
	try{
	    Class.forName("com.mysql.cj.jdbc.Driver");
	    Connection conn_mysql = DriverManager.getConnection(url_mysql,id_mysql,pw_mysql);
	    Statement stmt_mysql = conn_mysql.createStatement();
	
	    String A = "insert into user (uid,upassword,uname,ugender,uemail,uphone,uinsertdate ";
	    String B = ") values (?,?,?,?,?,?,now())";
	
	    ps = conn_mysql.prepareStatement(A+B);
	    ps.setString(1, uid);
	    ps.setString(2, upassword);
	    ps.setString(3, uname);
	    ps.setInt(4, ugender);
	    ps.setString(5, uemail);
	    ps.setString(6, uphone);
	    
	    ps.executeUpdate();
	
	    conn_mysql.close();
	} 
	
	catch (Exception e){
	    e.printStackTrace();
	}
%>

