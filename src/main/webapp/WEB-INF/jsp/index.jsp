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
    <script>
        function go(){
            $('.go_btn').toggleClass('on');
            $('.input_title').focus();
        }
        function apply(){
            $('.apply_btn').toggleClass('on');
            $('.input_title').prop('disabled', true);
        }
        function upload(){
            $('.input_description').prop('disabled', true);
            $('.upload_btn').prop('disabled',true);
            $('.loading').show();
            postData('/upload', {
                title: $('.input_title').val(),
                description: $('.input_description').val(),
                created: new Date().getTime(),
            }).then((data) => {
                console.log(data); // JSON 데이터가 `data.json()` 호출에 의해 파싱됨
                $('.loading').hide();
            });
        }
        function list(){
        }
        function validate(type = 'default'){
            let v, r = false;
            switch(type){
                case 'default':
                case 'title':
                    v = $('.input_title').val();
                    r = v ? false : true;
                    $('.apply_btn').prop('disabled',r);
                    if(type == 'title'){break;}
                case 'description':
                    v = $('.input_description').val();
                    r = v ? false : true;
                    $('.upload_btn').prop('disabled',r);
                    if(type == 'description'){break;}
            }
            return !r;
        }

        $(document).on('click','.go_btn', go);
        $(document).on('click','.list_btn', list);
        $(document).on('click','.apply_btn', apply);
        $(document).on('click','.upload_btn', upload);
        $(document).on('click','.header_sub', e => {if(loginData){logout();}else{modal(template.login);}});

        $(document).on('input','.input_title', e => {validate('title')});
        $(document).on('input','.input_description', e => {validate('description')});

        $(document).on('keypress','.input_title', e => {if(event.key == 'Enter' && validate('title')){apply();}});




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
        <a href="/index" class="logo">SuperScheduler</a>
        <a href="javascript:void(0);" class="header_sub">Sign in</a>
    </header>
    <main>
        <div class="board_list on">
            <div class="li">
                <svg>
                    <rect width="100%" height="100%" stroke-dasharray="16 1 0" stroke-dashoffset="16px" stroke="black" fill="transparent" />
                </svg>
                <div class="level" value="높음"></div>
                <div class="title">테스트 제목입니다</div>
                <div class="view_cnt">32</div>
            </div>
        </div>
        <div>
            <button class="go_btn">write</button>
            <button class="list_btn">list</button>
            <input type="text" class="input_title" placeholder="제목을 입력해 주세요.">
            <button class="apply_btn" disabled>apply title</button>
            <textarea class="input_description" placeholder="내용을 입력해 주세요."></textarea>
            <button class="upload_btn" disabled>upload</button>
        </div>
    </main>
    <footer>by <a href="https://github.com/starry-asterisk" style="color:cornflowerblue">@starry-asterisk</a></footer>
</div>
</body>
</html>