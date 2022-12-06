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
        $(document).on('click','.go_btn', go);
        $(document).on('click','.list_btn', ()=>{list();});
        $(document).on('click','.apply_btn', apply);
        $(document).on('click','.upload_btn', upload);
        $(document).on('click','.header_sub', () => {if(loginData){logout();}else{modal(template.login);}});
        $(document).on('click','.board_list .li .title', e => {$(e.target).parent().toggleClass("on");});
        $(document).on('click','.board_list .li.my .board_del', boardDel);
        $(document).on('click','.board_list .li.my .board_edit', boardEdit);
        $(document).on('click','.board_list .li .board_reply', boardReply);
        $(document).on('click','.board_list .li .checkbox', e=>{$(e.target).parents('.li').toggleClass('checked')});
        $(document).on('click','.board_list .li:not(.my) .board_del, .board_list .li:not(.my) .board_edit', () => {toast('본인이 작성한 글만 수정, 삭제 가능합니다.',TOAST_LONG);});

        $(document).on('input','.input_title', () => validate('title'));
        $(document).on('input','.input_description', () => validate('description'));

        $(document).on('keypress','.input_title', e => {if(e.key === 'Enter' && validate('title')){apply();}});
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
        <div class="board_list"></div>
        <div>
            <button class="go_btn">write</button>
            <button class="list_btn">list</button>
            <input type="text" class="input_title" placeholder="제목을 입력해 주세요.">
            <button class="apply_btn" disabled>apply title</button>
            <text-editor class="input_description" placeholder="내용을 입력해 주세요."></text-editor>
            <div class="input_etc">
                <selectmenu class="input_level" placeholder="우선순위" tabIndex="-1">
                    <option value="1">낮음</option>
                    <option value="2">중간</option>
                    <option value="3">높음</option>
                    <option value="0" selected="true">기타</option>
                </selectmenu>
                <input type="date">
            </div>
            <div></div>
            <button class="upload_btn" disabled>upload</button>
        </div>
    </main>
    <footer>by <a href="https://github.com/starry-asterisk" style="color:cornflowerblue">@starry-asterisk</a></footer>
</div>
</body>
</html>