<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
String res = (String)request.getAttribute("resvalue");

if(res != null){
%>
	{
		"flag" : "사용 불가능 id입니다"
	}
<% 
}else{ 
%>
	{
		"flag" : "사용 가능 id입니다"
	}
<%
}
%>