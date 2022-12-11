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
    <link href="${rootPath}/css/boards/detail.css" rel="stylesheet">

    <title>SuperScheduler :: main</title>

    <script>
        /*
        기본 변수 선언 부
        */
        let loginData = ${user!=null?user:'undefined'};
        let created_dt = new Date(${boards.created}).toLocaleString();
        let board_id = '${boards.id}';
    </script>
    <script src="https://code.jquery.com/jquery-3.6.1.slim.js" integrity="sha256-tXm+sa1uzsbFnbXt8GJqsgi2Tw+m4BLGDof6eUPjbtk=" crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-OERcA2EqjJCMA+/3y+gxIOqMEjwtxJY7qPCqsdltbNJuaOe923+mo//f6V8Qbsw3" crossorigin="anonymous"></script>
    <script type="text/javascript" src="${rootPath}/js/util/default.js"></script>
    <script type="text/javascript" src="${rootPath}/js/util/net.js"></script>
    <script type="text/javascript" src="${rootPath}/js/util/user.js"></script>
    <script type="text/javascript" src="${rootPath}/js/util/textEditor.js"></script>
    <script type="text/javascript" src="${rootPath}/js/util/boards/detail.js"></script>
    <script>
        $(document).on('click','.header_sub', () => {if(loginData){logout();}else{modal(template.login);}});
        $(document).on('keypress','.reply_simple', e => {if(e.key === 'Enter'){
            e.target.classList.remove('on');
            document.querySelector('.reply_detailed').dispatchEvent(new CustomEvent('editor_send', {detail: e.target.value}));
            e.target.value = '';
        }});
        $(document).on('click','.reply_submit', put_reply);

        $(document).ready(() => {
           $('.created').text(created_dt);
           if(loginData){
               document.body.classList.add("login");
               if(loginData.name === "${boards.author}"){
                   document.body.classList.add("my");
               }
           }
            list();
        });
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
        <div class="boards_wrap">
            <div class="title" danger_level="${boards.danger_level}">
                ${boards.title}
            </div>
            <div class="info_bar">
                <span class="author_nickname">${boards.author_nickname}</span>
                <span class="created"></span>
                <button data-id="${boards.id}" class="checkbox" icon="&#xF5DD" title="삭제"></button>
                <button data-id="${boards.id}" class="checkbox" icon="&#xF5DB" title="수정"></button>
                <button data-id="${boards.id}" class="checkbox" icon="&#xF51F" title="댓글로 이동"></button>
            </div>
            <pre class="contents">${boards.contents}</pre>
            <div class="reply_editor">
                <button class="reply_submit"></button>
                <input class="reply_simple on" type="text" placeholder="ENTER 누르면 상세한 작성 모드"/>
                <text-editor class="reply_detailed" placeholder="댓글을 작성해 주세요."></text-editor>
            </div>
            <div class="reply_list"></div>
        </div>
    </main>
    <footer>by <a href="https://github.com/starry-asterisk" style="color:cornflowerblue">@starry-asterisk</a></footer>
</div>
</body>
</html>