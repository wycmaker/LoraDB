<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="map.aspx.cs" Inherits="Lora.MAP" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/tocas-ui/2.3.3/tocas.css" />
    <script src="https://cdnjs.cloudflare.com/ajax/libs/tocas-ui/2.3.3/tocas.js"></script>
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
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
    <script>
        // 變數宣告
        var map;
        var newmaker;
        var SafeArea;
        var timeoutID;
        var Area;
        var GPSData1 = {
            id:1,
            position: {
                lat: null,
                lng: null
            },
            check: false
        };
        var GPSData2 = {
            id:2,
            position: {
                lat: null,
                lng: null
            },
            check: false
        };
        var audio;

        // 初始化地圖
        function initMap() {
            var Quemoy = { lat: 24.449818, lng: 118.322493 };
            map = new google.maps.Map(document.getElementById('map'), {
                zoom: 18.5,
                center: Quemoy
            });

            let simplePolyline = [
                { lat: 24.450201, lng: 118.322513 },
                { lat: 24.449748, lng: 118.323032 },
                { lat: 24.449238, lng: 118.322485 },
                { lat: 24.449731, lng: 118.321977 },
                { lat: 24.450201, lng: 118.322513 }
            ];
            SafeArea = new google.maps.Polygon({
                path: simplePolyline,
                strokeColor: '#03fc28',
                strokeOpacity: 0.8,
                strokeWeight: 4,
                fillColor: '#03fc28',
                fillOpacity: 0.35
            });
            SafeArea.setMap(map);

            new google.maps.Circle({
                center: Quemoy,
                radius: 150,
                strokeOpacity: 0,
                fillColor: '#f08205',
                fillOpacity: 0.24,
                map: map
            });
        }

        // 初始化頁面

        window.onload = SetUp()

        function SetUp() {
            setInterval("refresh()", "5000")
        }

        // 區域判斷
        //var x = 24.450063
        //function test() {
            
        //    if (GPSData1.check == false) {
        //        x -= 0.0001
        //    }
        //    GPSData1.position = { lat: x, lng: 118.322555 }
        //    ShowArea(GPSData1)
        //}

        function MusicControl() {
            audio = document.getElementById("music1")
            if (audio !== null) {
                if (audio.paused) {
                    audio.play()
                }
            }
        }

        function ShowArea(x) {
            
            Area = new google.maps.LatLng(x.position.lat, x.position.lng)
            if (x.check == false) {
                if (google.maps.geometry.poly.containsLocation(Area, SafeArea)) {
                    console.log("安全")
                } else {
                    MusicControl()
                    if (confirm("編號" + x.id + "超出範圍")) {
                        audio.pause()
                        x.check = true
                    }
                    
                }
            }
            if (x.check == true) {
                if (google.maps.geometry.poly.containsLocation(Area, SafeArea)) {
                    x.check = false
                }
            }
        }

        //取得GPS資料

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
                        if (list[3] == 1) {
                            GPSData1.position = {
                                lat: parseFloat(list[0]),
                                lng: parseFloat(list[1])
                            }
                            ShowArea(GPSData1)
                        }
                        if (list[3] == 2) {
                            GPSData2.position = {
                                lat: parseFloat(list[0]),
                                lng: parseFloat(list[1])
                            }
                            ShowArea(GPSData2)
                        }
                    }
                }
            });
        }


        //設立標記點
        function ShowGPSData(x) {
            if (newmaker) newmaker.setMap(null)
            if (x == 1) {
                newmaker = new google.maps.Marker({
                    position: GPSData1.position,
                    map: map
                });
            }
            if (x == 2) {
                newmaker = new google.maps.Marker({
                    position: GPSData2.position,
                    map: map
                });
            }
        }

        // 按鈕設置
        function StartTimer() {
            StopTimer2();
            timeoutID = setInterval("ShowGPSData(1)", "5000");
            document.getElementById("button1").disabled = true;
            document.getElementById("button2").disabled = false;
        }

        function StartTimer2() {
            StopTimer();
            timeoutID = setInterval("ShowGPSData(2)", "5000");
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
    <script async="async" defer="defer" src="https://maps.googleapis.com/maps/api/js?key=AIzaSyCxEO_TB_AzCl3GXqhdJVQ41on_XvxgkS0&libraries=geometry&callback=initMap"></script>
</head>
<body>
    <!-- 側欄 -->
    <form id="form1" runat="server">
        <div class="ts left vertical fluid inverted visible menu sidebar">
            <!-- 搜尋欄位 -->
            <div class="fitted item">
                <div class="ts icon fluid basic borderless inverted input">
                    <input type="text" placeholder="搜尋" />
                    <i class="search inverted link icon"></i>
                </div>
            </div>
            <!-- / 搜尋欄位 -->
            <!-- 老人家資料 -->
            <div class="ts divided items">
                <!-- 其中一位 -->
                <div class="item">
                    <div class="ts tiny image" style="margin-left: 15px">
                        <img class="ts tiny rounded image" src="images/陳佳駿.jpg" />
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
                            <button class="ts mini circular negative button" onclick="StopTimer()" id="button2" disabled="disabled">■</button>
                        </div>

                    </div>
                </div>
                <!-- / 其中一位 -->
                <!-- 其中一位 -->
                <div class="item">
                    <div class="ts tiny image" style="margin-left: 15px">
                        <img class="ts tiny rounded image" src="images/陳憲億.jpg" />
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
                            <button class="ts mini circular negative button" onclick="StopTimer2()" id="button4" disabled="disabled">■</button>
                        </div>
                    </div>
                </div>
                <!-- / 其中一位 -->
            </div>
            <audio src="../images/alert.mp3" loop ="loop" controls="controls" preload="auto" id="music1" hidden="hidden" />
            <!-- / 老人家資料 -->
            <!-- 底部選單 -->
            <div class="bottom menu">
                <!-- 登出 -->
                <a class="item" href="main.html">回上頁</a>
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
