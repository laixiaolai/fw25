var App = {};

//JavaScript将信息发给Objective-C:
//登录成功
(function initialize() {
    App.login_success= function (app_data) {
        window.webkit.messageHandlers.login_success.postMessage(app_data);
    };
 })();

//退出登录
(function initialize() {
     App.logout = function (app_data) {
        window.webkit.messageHandlers.logout.postMessage(app_data);
     };
 })();

(function initialize() {
     App.onConfirm = function (app_data) {
        onConfirm(app_data);
     };
 })();

//第三放sdk支付
(function initialize() {
     App.pay_sdk = function (app_data) {
        window.webkit.messageHandlers.pay_sdk.postMessage(app_data);
     };
 })();

//主要用在：调用wap支付方式时，要打开一个：新的webview界面； 或打开外部广告连接地址时，使用
(function initialize() {
     App.open_type = function (app_data) {
        window.webkit.messageHandlers.open_type.postMessage(app_data);
     };
 })();

//分享
(function initialize() {
     App.sdk_share = function (app_data) {
        window.webkit.messageHandlers.sdk_share.postMessage(app_data);
     };
 })();

//获取剪切板内容
(function initialize() {
     App.getClipBoardText = function () {
        var data="haah";
        window.webkit.messageHandlers.getClipBoardText.postMessage(data);
     
     };
 })();

//裁剪图片
(function initialize() {
     App.CutPhoto = function (app_data) {
        window.webkit.messageHandlers.CutPhoto.postMessage(app_data);
     };
 })();

//重启
(function initialize() {
     App.restart = function () {
         var data="haah";
         window.webkit.messageHandlers.restart.postMessage(data);
     };
 })();

//推送
(function initialize() {
     App.apns = function () {
         var data="haah";
         window.webkit.messageHandlers.apns.postMessage(data);
     };
 })();

//百度地图获取经纬度等
(function initialize() {
     App.position = function () {
         var data="haah";
         window.webkit.messageHandlers.position.postMessage(data);
     };
 })();

(function initialize() {
     App.position2 = function () {
     var data="haah";
     window.webkit.messageHandlers.position2.postMessage(data);
     };
 })();

//扫码
(function initialize() {
     App.qr_code_scan = function () {
         var data="haah";
         window.webkit.messageHandlers.qr_code_scan.postMessage(data);
     };
 })();

//登录
(function initialize() {
     App.login_sdk = function (app_data) {
         window.webkit.messageHandlers.login_sdk.postMessage(app_data);
     };
 })();

//判断是否安装了某个应用
(function initialize() {
     App.is_exist_installed = function (app_data) {
         window.webkit.messageHandlers.is_exist_installed.postMessage(app_data);
     };
 })();

//创建直播间
(function initialize() {
     App.create_live = function (app_data) {
         window.webkit.messageHandlers.create_live.postMessage(app_data);
     };
 })();

//加入房间
(function initialize() {
     App.join_live = function (app_data) {
         window.webkit.messageHandlers.join_live.postMessage(app_data);
     };
 })();

//个人中心页面的点击：直播，等级，收益，账户等页面
(function initialize() {
     App.start_app_page = function (app_data) {
         window.webkit.messageHandlers.start_app_page.postMessage(app_data);
     };
 })();

//回退
(function initialize() {
     App.page_finsh = function () {
         var data="haah";
         window.webkit.messageHandlers.page_finsh.postMessage(data);
     };
 })();

//回退2
(function initialize() {
     App.close_page = function () {
         var data="a";
         window.webkit.messageHandlers.close_page.postMessage(data);
     };
 })();

//加载个人信息
(function initialize() {
     App.getuserinfo = function (app_data) {
         window.webkit.messageHandlers.getuserinfo.postMessage(app_data);
     };
 })();

//加载个人信息
(function initialize() {
     App.js_getuserinfo = function (app_data) {
         window.webkit.messageHandlers.js_getuserinfo.postMessage(app_data);
     };
 })();

//呼出直播小屏
(function initialize() {
     App.shopping_join_live = function (app_data) {
         window.webkit.messageHandlers.shopping_join_live.postMessage(app_data);
     };
 })();

//观众加入直播间回调
(function initialize() {
     App.js_shopping_join_live = function (app_data) {
         window.webkit.messageHandlers.js_shopping_join_live.postMessage(app_data);
     };
 })();

//h5回退直播间回调
(function initialize() {
     App.js_shopping_comeback_live_app = function (app_data) {
         window.webkit.messageHandlers.js_shopping_comeback_live_app.postMessage(app_data);
     };
 })();

//呼出直播应用
(function initialize() {
     App.shopping_start_live_app = function (app_data) {
         window.webkit.messageHandlers.shopping_start_live_app.postMessage(app_data);
     };
 })();

//启动应用回调
(function initialize() {
     App.js_shopping_start_live_app = function (app_data) {
         window.webkit.messageHandlers.js_shopping_start_live_app.postMessage(app_data);
     };
 })();

//呼出发起直播
(function initialize() {
     App.shopping_create_live = function (app_data) {
         window.webkit.messageHandlers.shopping_create_live.postMessage(app_data);
     };
 })();

//live type
(function initialize() {
     App.js_get_live_type = function (app_data) {
         window.webkit.messageHandlers.js_get_live_type.postMessage(app_data);
     };
 })();


//以下是用方式是UIWebview
(function initialize() {
     App.check_network = function (app_data) {
         check_network(app_data);
     };
 })();

(function initialize() {
     App.refresh_reload = function (app_data) {
         refresh_reload(app_data);
     };
 })();
