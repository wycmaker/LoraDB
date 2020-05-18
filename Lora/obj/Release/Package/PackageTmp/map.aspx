<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="map.aspx.cs" Inherits="Lora.MAP" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/tocas-ui/2.3.3/tocas.css">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/tocas-ui/2.3.3/tocas.js"></script>
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title></title>
    <style>
        .squeezable {
            height: 100%;
        }

        #map {
            height: 100%;
        }
    </style>
    <script type="text/javascript" src="https://cdn.polyfill.io/v2/polyfill.min.js?features=es6"></script>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
    <script async="async" defer="defer" src="https://maps.googleapis.com/maps/api/js?key=AIzaSyCxEO_TB_AzCl3GXqhdJVQ41on_XvxgkS0&callback=initMap"></script>

    <script>
        var map, newmaker, item
        var x = 24.43899;
        var y = 118.31771;
        function initMap() { // 地圖起始位置
            var Quemoy = { lat: 24.448636, lng: 118.320614 };
            map = new google.maps.Map(document.getElementById('map'), {
                zoom: 18,
                center: Quemoy
            });
        }

        function refresh() {
            $.ajax({
                url: 'map.aspx/HelloWorld',
                type: 'GET',
                async: false,
                contentType: 'application/json; charset=UTF-8',
                dataType: "json", // 如果要回傳值，請設成 json
                error: function (xhr) { console.log(xhr) },
                success: function (data) {
                    if (data.d != "err") {
                        if (data.d == "NO_GPS") { // 什麼事都不做，讓前端不會當機
                        }
                        var list = data.d.split(',')
                        if (newmaker) newmaker.setMap(null) // 地圖
                        newmaker = new google.maps.Marker({
                            position: { lat: parseFloat(list[0]), lng: parseFloat(list[1]) },
                            map: map
                        }); // 地圖程式到這
                        console.log(list)
                        document.getElementById("show").innerHTML += `
                            <tr>
                                <td>${list[3]}</td>
                                <td>${list[0]}</td>
                                <td>${list[1]}</td>
                                <td>${list[2]}</td>
                            </tr>
                        `
                        var count = document.getElementById("show").rows.length;
                        if (count > 6) {
                            document.getElementById("show").deleteRow(1);
                        }
                    }
                }
            });
        }

        var timeoutID;
        function StartTimer() {
            timeoutID = setInterval("refresh()", "5000");
            document.getElementById("button1").disabled = true;
            document.getElementById("button2").disabled = false;
        }

        function StartTimer2() {
            timeoutID = setInterval("refresh()", "5000");
            document.getElementById("button3").disabled = true;
            document.getElementById("button4").disabled = false;
        }

        function StopTimer() {
            clearInterval(timeoutID);
            document.getElementById("button1").disabled = false;
            document.getElementById("button2").disabled = true;
        }

        function StopTimer2() {
            clearInterval(timeoutID);
            document.getElementById("button3").disabled = false;
            document.getElementById("button4").disabled = true;
        }
    </script>

</head>
<body>
    <!-- 側欄 -->
    <form id="form1" runat="server">
        <div class="ts left vertical fluid inverted visible menu sidebar">
            <!-- 搜尋欄位 -->
            <div class="fitted item">
                <div class="ts icon fluid basic borderless inverted input">
                    <input type="text" placeholder="搜尋">
                    <i class="search inverted link icon"></i>
                </div>
            </div>
            <!-- / 搜尋欄位 -->
            <!-- 老人家資料 -->
            <div class="ts divided items">
                <!-- 其中一位 -->
                <div class="item">
                    <div class="ts tiny image" style="margin-left: 15px">
                        <img class="ts tiny rounded image" src="images/陳佳駿.jpg">
                    </div>
                    <div class="content">
                        <div class="header" style="color: #ffffff">陳佳駿</div>
                        <div class="inline meta">
                            <span></span>
                        </div>
                        <div class="description" style="color: #ffffff">
                            1997.09.30
                            <p style="margin-top: 8px"></p>
                            <button class="ts mini circular positive button" onclick="StartTimer()" id="button1">▶</button>&nbsp;
                            <button class="ts mini circular negative button" onclick="StopTimer()" id="button2">■</button>
                        </div>

                    </div>
                </div>
                <!-- / 其中一位 -->
                <!-- 其中一位 -->
                <div class="item">
                    <div class="ts tiny image" style="margin-left: 15px">
                        <img class="ts tiny rounded image" src="images/陳憲億.jpg">
                    </div>
                    <div class="content">
                        <div class="header" style="color: #ffffff">陳憲億</div>
                        <div class="inline meta">
                            <span></span>
                        </div>
                        <div class="description" style="color: #ffffff">
                            1998.03.25
                            <p style="margin-top: 8px"></p>
                            <button class="ts mini circular positive button" onclick="StartTimer2()" id="button3">▶</button>&nbsp;
                            <button class="ts mini circular negative button" onclick="StopTimer2()" id="button4">■</button>
                        </div>

                    </div>
                </div>
                <!-- / 其中一位 -->
            </div>
            <!-- / 老人家資料 -->
            <!-- 底部選單 -->
            <div class="bottom menu">
                <!-- 登出 -->
                <a class="item" href="Default.html">回上頁</a>
                <!-- / 登出 -->
            </div>
            <!-- / 底部選單 -->
        </div>
        <!-- / 側欄 -->

        <!-- 可擠壓式的推動容器 -->
        <div class="squeezable pusher">
            <div id="map">
                <div id="mapview"></div>
            </div>
        </div>
        <!-- / 可擠壓式的推動容器 -->
    </form>
</body>
</html>
