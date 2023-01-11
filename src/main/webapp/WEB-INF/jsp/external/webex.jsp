<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <link rel="shortcut icon" href="/img/favicon.ico" type="image/x-icon">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-Zenh87qX5JnK2Jl0vWa8Ck2rdkQ2Bzep5IDxbcnCeuOxjzrPF/et3URy9Bv1WTRi" crossorigin="anonymous">
    <link href="${rootPath}/css/theme.css" rel="stylesheet">
    <link href="${rootPath}/css/common.css" rel="stylesheet">
    <link href="${rootPath}/css/external/webex.css" rel="stylesheet">
    <title>SuperScheduler :: API test</title>

    <script>
        const rootPath = '${rootPath}';
        const WEBEX_ACCESS_TOKEN = '${access_token}';
    </script>
    <script src="https://code.jquery.com/jquery-3.6.1.slim.js" integrity="sha256-tXm+sa1uzsbFnbXt8GJqsgi2Tw+m4BLGDof6eUPjbtk=" crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-OERcA2EqjJCMA+/3y+gxIOqMEjwtxJY7qPCqsdltbNJuaOe923+mo//f6V8Qbsw3" crossorigin="anonymous"></script>
    <script type="text/javascript" src="${rootPath}/js/util/default.js"></script>
    <script type="text/javascript" src="${rootPath}/js/util/net.js"></script>
    <script type="text/javascript" src="${rootPath}/js/lib/webex-bundle.js"></script>
    <script type="module" src="${rootPath}/js/util/external/webex.js"></script>
</head>
<body>
<div class="modal_wrap">
    <div class="modal_window">
        <button class="modal_close"></button>
    </div>
</div>
<div class="loading"></div>
<div class="wrap">
    <header>
        <a href="/" class="logo">SuperScheduler</a>
    </header>
    <main>
        <div class="rooms_list_wrap">
            <span class="custom-scrollbar"></span>
            <div class="sticky_menu">
                <input type="radio" name="room_type" value="all" label="전체" checked>
                <input type="radio" name="room_type" value="direct" label="다이렉트">
                <input type="radio" name="room_type" value="space" label="스페이스">
            </div>
            <ul class="rooms_list">

            </ul>
        </div>
        <div class="room_detail">
            <div class="messages_list_wrap">
                <span class="custom-scrollbar"></span>
                <div class="sticky_menu room_title"></div>
                <ul class="messages_list">

                </ul>
            </div>
            <div class="message_form">
                <div contenteditable="plaintext-only" class="message_input"></div>
                <button class="message_submit"></button>
            </div>
        </div>
    </main>
    <footer>by <a href="https://github.com/starry-asterisk" style="color:cornflowerblue">@starry-asterisk</a></footer>
</div>
</body>
</html>