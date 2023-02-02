<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
String url=""+request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()
+request.getContextPath()+"/";
%>
<!DOCTYPE html>
<html>
<head>
  <base href="<%=url%>">
  <meta charset="UTF-8">
    <title>Title</title>
  <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
  <script type="text/javascript" src="jquery/echarts/echarts.min.js"></script>
  <script type="text/javascript">
    $(function () {
/*      // 基于准备好的dom，初始化echarts实例
      var myChart = echarts.init(document.getElementById('chartDiv'));

      // 指定图表的配置项和数据
      var option = {
        title: {
          text: 'ECharts 入门示例'
        },
        tooltip: {},
        legend: {
          data: ['销量']
        },
        xAxis: {
          data: ['衬衫', '羊毛衫', '雪纺衫', '裤子', '高跟鞋', '袜子']
        },
        yAxis: {},
        series: [
          {
            name: '销量',
            type: 'bar',
            data: [5, 20, 36, 10, 10, 20]
          }
        ]
      };

      // 使用刚指定的配置项和数据显示图表。
      myChart.setOption(option);*/

      $.ajax({
        url:"workbench/chart/transaction/returnCharPojo",
        type:'post',
        dataType:'json',
        success:function (data) {
          // 基于准备好的dom，初始化echarts实例
          var myChart = echarts.init(document.getElementById('chartDiv'));
          // 指定图表的配置项和数据
          option = {
            title: {
              text: '交易统计图表'
            },
            tooltip: {
              trigger: 'item',
              formatter: '{a} <br/>{b} : {c}'
            },
            toolbox: {
              feature: {
                dataView: { readOnly: false },
                restore: {},
                saveAsImage: {}
              }
            },
            series: [
              {
                name: '数据量',
                type: 'funnel',
                left: '10%',
                width: '80%',
                label: {
                  formatter: '{b}'
                },
                labelLine: {
                  show: false
                },
                itemStyle: {
                  opacity: 0.7
                },
                emphasis: {
                  label: {
                    position: 'inside',
                    formatter: '{b}:{c}'
                  }
                },
                data:data
              }
            ]
          };

          // 使用刚指定的配置项和数据显示图表。
          myChart.setOption(option);
        }
      })
    })
  </script>
</head>
<body>
<div id="chartDiv" style="width: 800px;height:500px;"></div>
</body>
</html>
