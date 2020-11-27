<%@ page import="DAL.*" errorPage="_Error.jsp" %>
<%@ page import="java.util.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	String path = request.getContextPath();//获取项目名称
%>
<!doctype html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" type="text/css" href="../Style/EditStyle.css"/>
<script type="text/javascript" src="<%=path %>/Script/jquery-1.10.1.js"></script>
<script type="text/javascript">
	$(function()
	{		
		//取消按钮点击事件
		$("#btnCancel").click(function()
		{
			location.href="<%=path %>/TempHandle?type=4";//点击后跳转至TempHandle Servlet页面
		});
		
		//获取当前时间
		$("[name=out_date]").val(getNowFormatDate());
		$("[name=out_time]").val(getNowFormatTime());
		
		var dateEntry=$("[name=entry_date]").val()+" "+$("[name=entry_time]").val();
		var dateOut=$("[name=out_date]").val()+" "+$("[name=out_time]").val();
		
		var lessTime=new Date(dateOut).getTime()-new Date(dateEntry).getTime();
		
		var hours=parseInt((lessTime)/(1000*60));
		$("[name=time]").val(hours);
		$("[name=temp_money]").val($("[name=price]").val()*hours);
		
		$("[name=price]").blur(function()
		{
			$("[name=temp_money]").val($("[name=price]").val()*hours);
		});
		
	});
	
	function getNowFormatDate() {
	    var date = new Date();
	    var seperator1 = "-";
	    var year = date.getFullYear();
	    var month = date.getMonth() + 1;
	    var strDate = date.getDate();
	    if (month >= 1 && month <= 9) {
	        month = "0" + month;
	    }
	    if (strDate >= 0 && strDate <= 9) {
	        strDate = "0" + strDate;
	    }
	    var currentdate = year + seperator1 + month + seperator1 + strDate;
	    return currentdate;
	}
	
	function getNowFormatTime()
	{
		var date = new Date();
		var seperator2 = ":";
		var currentTime= date.getHours() + seperator2 + date.getMinutes()+ seperator2 + date.getSeconds();
		return currentTime;
	}
var chargeTime = <%=DAL.Temp.getCharge()%>;
$(document).ready(function(){
	//获取入场时间
	var entryTime = $("[name=entry_date]").val() + ' ' + $("[name=entry_time]").val();
	entryTime = entryTime.replace(/-/g,'/'); 
	var entryDate = new Date(entryTime);
	var outDate = new Date();
	var time = outDate.getTime() - entryDate.getTime();
	time = parseInt(time/1000/60);
	$("[name=temp_money]").val(charge(time));
});
function charge(time){
	var flagKey = 20;
	for(var key in chargeTime){
		if(time <= key){
			flagKey = key;
			break;
		}
	}
	if(time >60){
		//表示超过一个小时
		time = parseInt(time/60);
		return chargeTime[61] * time;
	}
	return chargeTime[flagKey];
}
</script>

</head>
<body>
	<%
		response.setCharacterEncoding("UTF-8");//设置输出编码格式
		String temp_id=request.getParameter("temp_id").toString();//获取url传过来的temp_id
	        DAL.Temp temp=new DAL.Temp();//实例化Temp对象
	        List<Object> tempList=temp.getEntityById(temp_id);//根据ID获取Temp数据
	        Object[] obj=(Object[])tempList.get(0);//将List数据转换成Object[]
	        String chargeMap = DAL.Temp.getCharge();  
	 %>
	 <form action="<%=path %>/TempHandle?type=2" method="post">
		<table style=" margin:50px auto;">
	            <tbody>
			 <tr><td>零时编号：</td><td><input type="text" name="temp_id" value="<%=obj[0] %>" readonly="readonly" /></td></tr>
			 <tr><td>ID编号：</td><td><input type="text" name="card_id" value="<%=obj[1] %>" readonly="readonly" /></td></tr>
			 <tr><td>车辆编号：</td><td><input type="text" name="car_num" value="<%=obj[2] %>" readonly="readonly" /></td></tr>
			 <tr><td>入场日期：</td><td><input type="text" name="entry_date" value="<%=obj[3] %>" readonly="readonly" /></td></tr>
			 <tr><td>入场时间：</td><td><input type="text" name="entry_time" value="<%=obj[4] %>" readonly="readonly" /></td></tr>
			 <tr><td>出场日期：</td><td><input type="text" name="out_date" value="" readonly="readonly" /></td></tr>
			 <tr><td>出场时间：</td><td><input type="text" name="out_time" value="" readonly="readonly" /></td></tr>
			 <tr><td>停车时间：</td><td><input type="text" name="time" value="" readonly="readonly" style="width:140px" />分钟</td></tr>
			 <tr><td>停车单价：</td><td><input type="hidden" name="price" value="3" style="width:140px" />前20分钟吗免费，20-60分钟内收费5元，后面每超过1小时收费7元</td></tr>
			 <tr><td>总费用：</td><td><input type="text" name="temp_money" style="width:140px" value="<%=obj[7] %>"  readonly="readonly" />元</td></tr>
		    </tbody>   
	            
	            <tfoot>
	                <tr><td><input type="submit" value="确定" id="btnSure"/></td><td><input type="button" value="取消" id="btnCancel"/></td></tr>
	            </tfoot> 
	        </table>
     </form>
</body>
</html>
