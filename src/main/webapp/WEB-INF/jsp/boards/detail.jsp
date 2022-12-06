<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <link rel="shortcut icon" href="/img/favicon.ico" type="image/x-icon">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-Zenh87qX5JnK2Jl0vWa8Ck2rdkQ2Bzep5IDxbcnCeuOxjzrPF/et3URy9Bv1WTRi" crossorigin="anonymous">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="${rootPath}/css/theme.css" rel="stylesheet">
    <link href="${rootPath}/css/common.css" rel="stylesheet">
    <link href="${rootPath}/css/index.css" rel="stylesheet">

    <title>SuperScheduler :: main</title>

    <script>
        /*
        기본 변수 선언 부
        */
        let loginData = ${user!=null?user:'undefined'};

    </script>
    <script src="https://code.jquery.com/jquery-3.6.1.slim.js" integrity="sha256-tXm+sa1uzsbFnbXt8GJqsgi2Tw+m4BLGDof6eUPjbtk=" crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-OERcA2EqjJCMA+/3y+gxIOqMEjwtxJY7qPCqsdltbNJuaOe923+mo//f6V8Qbsw3" crossorigin="anonymous"></script>
    <script type="text/javascript" src="${rootPath}/js/util/default.js"></script>
    <script type="text/javascript" src="${rootPath}/js/util/net.js"></script>
    <script type="text/javascript" src="${rootPath}/js/util/user.js"></script>
    <script type="text/javascript" src="${rootPath}/js/util/textEditor.js"></script>
    <script type="text/javascript" src="${rootPath}/js/util/index.js"></script>
    <script>
    </script>
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
        <a href="javascript:void(0);" class="header_sub">Sign in</a>
    </header>
    <main>
        <div class="board_list on">
            <div class="li my on" data-id="${boards.id}">
                <svg><rect height="100%" width="100%"></rect></svg>
                <div class="level" value="${boards.danger_level}">
                    <span class="checkbox"></span>
                </div>
                <div class="title">${boards.title}</div>
                <div class="author_nickname">${boards.author_nickname}</div>
                <div class="li_detail">
                    <div class="info_bar">
                        <button data-id="${boards.id}" class="board_del" icon="" title="삭제"></button>
                        <button data-id="${boards.id}" class="board_edit" icon="" title="수정"></button>
                        <button data-id="${boards.id}" class="board_reply" icon="" title="댓글로 이동"></button>
                        <div class="created">${boards.created}</div>
                    </div>
                    <pre class="contents">${boards.contents}</pre>
                </div>
            </div>
        </div>
    </main>
    <footer>by <a href="https://github.com/starry-asterisk" style="color:cornflowerblue">@starry-asterisk</a></footer>
</div>
</body>
</html>