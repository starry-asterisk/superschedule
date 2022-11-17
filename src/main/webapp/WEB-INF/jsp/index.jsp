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

    <title>첫 페이지</title>

    <script src="https://code.jquery.com/jquery-3.6.1.slim.js" integrity="sha256-tXm+sa1uzsbFnbXt8GJqsgi2Tw+m4BLGDof6eUPjbtk=" crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-OERcA2EqjJCMA+/3y+gxIOqMEjwtxJY7qPCqsdltbNJuaOe923+mo//f6V8Qbsw3" crossorigin="anonymous"></script>
    <script type="text/javascript" src="${rootPath}/js/util/math.js"></script>
    <script type="text/javascript" src="${rootPath}/js/util/net.js"></script>
    <style>
        .go_btn.on,
        .apply_btn,
        .upload_btn,
        .go_btn.on ~ .list_btn{
            display: none;
        }
        .apply_btn.on{
            display: none !important;
        }
        .input_title, .input_description {
            display: block;
            width: 0;
            max-width: 45em;
            padding: 10px;
            height: 50px;
            min-height: 50px;
            transition: 1s width;
            margin: 0 auto;
            visibility: hidden;
        }
        .input_description {
            margin-top: 10px;
            text-align: left;
        }
        @keyframes description_appear {
            0% {
                height: 30px;
                width: 0;
            }
            50% {
                height: 30px;
                width: 100%;
            }
            100% {
                height: 200px;
                width: 100%;
            }
        }
        .go_btn.on ~ .input_title,
        .apply_btn.on ~ .input_description {
            width: 100%;
            visibility: visible;
        }
        .apply_btn.on ~ .input_description {
            animation: description_appear 1s linear;
            height: 200px;
        }
        .go_btn.on ~ .apply_btn,
        .apply_btn.on ~ .upload_btn {
            display: block;
            margin: 0 auto;
        }
        * + button[class*=_btn] {
            margin-top: 10px !important;
        }
    </style>
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
        function login(isAuto = false, token){
            console.log(isAuto, token);
            let data = {}
            if(isAuto){
                data.token = token;
            }else{
                data.id = prompt("아이디(ID)를 입력해 주세요");
                data.pw = prompt("비밀번호를 입력해 주세요");
                if(!data.id || !data.pw){
                   return alert("로그인 정보를 입력해 주세요!");
                }
            }
            $('.loading').show();
            postData('/login', data).then((data) => {
                $('.loading').hide();
                switch (data.status){
                    case 404:
                        console.warn("wrong login token or url is incorrect");
                        localStorage.removeItem('login_token');
                        if(!isAuto){
                            alert("로그인 실패!");
                        }
                        break;
                    case 200:
                        console.log("OK, login success");
                        if(!isAuto){
                            location.reload();
                        }
                }
            });
        }
        function load_loginData(){

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
        $(document).on('click','.to_project', login);

        $(document).on('input','.input_title', e => {validate('title')});
        $(document).on('input','.input_description', e => {validate('description')});

        $(document).on('keypress','.input_title', e => {if(event.key == 'Enter' && validate('title')){apply();}});

        let loginData = ${user};
        if(loginData){

        }else{
            let login_token = localStorage.getItem('login_token');
            if(login_token){
                login(true, login_token);
            }
        }
    </script>
</head>
<body>
<div class="loading"></div>
<div class="wrap">
    <header>
        <a href="/index" class="logo">SuperScheduler</a>
        <a href="javascript:void(0);" class="to_project">Sign in</a>
    </header>
    <main>
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