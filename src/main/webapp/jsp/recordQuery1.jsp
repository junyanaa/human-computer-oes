<%@ page import="com.oes.bean.Exam" %>
<%@ page import="java.util.List" %>
<%@ page import="com.oes.bean.Student" %>
<%@ page import="com.oes.bean.ExamLog" %><%--
  Created by IntelliJ IDEA.
  User: lancer
  Date: 2023/5/10
  Time: 20:38
  To change this template use File | Settings | File Templates.
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>记录查询</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        body {
            min-height: 100vh;
            background: url(/images/5.png) center / cover;
            display: flex;
            justify-content: center;
            align-items: center;
        }
        main.table {
            width: 77vw;
            height: 80vh;
            background-color: #fff5;
            box-shadow: 0 8px 16px #0005;
            border-radius: 16px;
            overflow: hidden;
        }
        .header {
            width: 100%;
            height: 10%;
            background-color: #fff4;
            padding: 0 40px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .header .input-group img {
            width: 20px;
            height: 20px;
        }
        .header .input-group input {
            width: 100%;
            background-color: transparent;
            border: none;
            outline: none;
        }
        .shell {
            width: 95%;
            max-height: calc(90% - 25px);
            background-color: #fffb;
            margin: 8px auto;
            border-radius: 10px;
            overflow: auto;
            overflow: unset;
        }
        .shell::-webkit-scrollbar {
            width: 10px;
            height: 10px;
        }
        table {
            width: 100%;
        }
        td img {
            width: 36px;
            height: 36px;
            margin-right: 10px;
            border-radius: 50%;
            vertical-align: middle;
        }
        table,
        th,
        td {
            border-collapse: collapse;
            padding: 20px;
            text-align: left;
        }
        thead th {
            position: sticky;
            top: 0;
            left: 0;
            background-color: #d5d1defe;
            cursor: pointer;
        }
        /* 偶数行背景色 */
        tbody tr:nth-child(even) {
            background-color: #0000000b;
        }
        tbody tr:hover {
            background-color: #fff6 !important;
        }
        .button {
            padding: 5px 0;
            border-radius: 10px;
            text-align: center;
        }
        tr:nth-child(4n) .button {
            background-color: #86e49d;
            color: #006b21;
        }
        tr:nth-child(4n-1) .button {
            background-color: #ebc474;
        }
        tr:nth-child(4n+1) .button {
            background-color: #d893a3;
            color: #b30021;
        }
        tr:nth-child(4n+2) .button {
            background-color: #6fcaea;
        }
        /*顶部按钮样式*/
        .container {
            /* 这个父元素设置了弹性布局 就能让子元素水平排列了,主要原理是让子元素在主轴水平排列 */
            display: flex;
            /* 设置了弹性布局的盒子的子元素是可以直接宽和高的 a标签是行内元素 不转为块级元素无法设置宽和高 但是只要是弹性项目 就可以设置 */
            flex-direction:row;
        }
        .op {
            /* 相对定位 子绝父相 */
            position: relative;
            width: 200px;
            border-radius: 10px;
            height: 60px;
            line-height: 60px;
            text-align: center;
            margin: 50px;
            font-size: 30px;
            color: #7f8;
            /* 这个是取消文字下划线 */
            text-decoration: none;
            border: 5px solid #7f8;
            /* 接下来就是四个盒子的颜色了 */
            /* 刚才定义--i这个属性值可以通过var函数来调用 */
            /* 刷一下就变了 哈哈 这块calc方法可以自动计算 var函数调用了刚刚我们给a设置的1-4这四个属性值,然后分别计算出了一个度数 hue-rotate这个属性是颜色滤镜 可以添加 不同的度数来改变颜色 最大值360deg 最小是就是0 原来的颜色 */
        }
        .op::before,
        .op::after {
            content: "";
            position: absolute;
            width: 15px;
            height: 5px;
            background-color: #353b48;
            /* 这个属性是倾斜 写了一个值就表示在水平方向的倾斜 和skewX是一样的 */
            transform: skew(50deg);
            /* 设置一下过渡时间 */
            transition: all 0.5s;
        }
        .op::before {
            top: -5px;
            left: 10%;
        }
        .op::after {
            bottom: -5px;
            right: 10%;
        }
        .op:hover::before {
            left: 80%;
        }
        .op:hover::after {
            right: 80%;
        }
        .overlay {
            color: #BFA725;
            position: fixed;
            top: 300px;
            left: 30%;
            width: 500px;
            height: 500px;
            display: none;
        }
        .popup {
            background-color: #416396;
            position: absolute;
            top: 50px;
            left: 50%;
            width: 300px;
            height: 150px;
            transform: translate(-50%, -50%);
            padding: 20px;
            border-radius: 5px;
        }
        .close {
            position: absolute;
            top: 10px;
            right: 10px;
            cursor: pointer;
            font-size: 10px;
        }
        .winLabel,.winButton,.winInput{
            font-size: 1.5rem;
            font-family: monospace;
            color: white;
        }
        .winLabel:focus,.winButton:focus,.winInput:focus{
            outline: 3px solid yellow;
            outline-offset: 2px;
        }
        .winInput::-moz-focus-inner,
        .winLabel::-moz-focus-inner,
        .winButton::-moz-focus-inner{
            border: none;
        }
        .winInput{
            padding: 0.75rem 4rem 0.75rem 0.75rem;
            width: 70%;
            border: 2px solid transparent;
            border-radius: 0;
            background-color: transparent;
            box-shadow: inset 0 0 0 2px black, inset 6px 6px 0 rgba(30, 144, 255, 0.2), 3px 3px 0 rgba(30, 144, 255, 0.2);
            -webkit-appearance: none;
        }
        .winButton{
            cursor: pointer;
            margin: 20px auto 0 2px;
            padding: 0.75rem 1.25rem;
            color: black;
            background-color: var(--inputColor);
            box-shadow: 4px 4px 0 rgba(30, 144, 255, 0.2);
            border: none;
        }
        .winButton:active{
            transform: translateY(1px);
        }
    </style>
    <script>
        function openForm() {
            document.getElementById("overlay").style.display = "block";
        }
        function closeForm() {
            document.getElementById("overlay").style.display = "none";
        }
    </script>
</head>
<body>
<div class="overlay" id="overlay">
    <div class="popup">
        <span class="close" onclick="closeForm()">&times;</span>
        <form action="${pageContext.request.contextPath}/allExamLog" method="post">
            <label class="winLabel" for="examId">
                <input class="winInput"  type="text" name="logExamId" id="examId" placeholder="输入考试ID">
            </label>
            <input class="winButton" type="submit" value="确认">
        </form>
    </div>
</div>
<main class="table">
    <section class="header">
        <div class="container">
            <button class="op" onclick="window.location.href='teaMain.jsp'">返回主页</button>
        </div>
        <div class="container">
            <button class="op" onclick="openForm()">考试ID</button>
        </div>
    </section>
    <section class="shell">
        <table id="tab1">
            <thead>
            <tr>
                <th>学号</th>
                <th>姓名</th>
                <th>科目</th>
                <th>成绩</th>
                <th></th>
            </tr>
            </thead>
            <tbody>
            </tbody>
        </table>
    </section>
</main>
</body>
</html>
