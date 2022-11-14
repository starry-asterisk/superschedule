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
    <style>
        .go_btn, .apply_btn {

        }
        .go_btn.on,
        .apply_btn,
        .go_btn.on + .hint {
            display: none;
        }
        .apply_btn.on{
            display: none !important;
        }
        .input_title, .input_description {
            display: block;
            width: 0;
            transition: 1s width;
            margin: 0 auto;
            visibility: hidden;
        }
        .input_description {
            transition: width 0.5s, height 0.5s ease 0.5s;
            height: 0px;
        }
        .go_btn.on ~ .input_title,
        .apply_btn.on ~ .input_description {
            width: 100%;
            visibility: visible;
        }
        .go_btn.on ~ .input_description {
            height: 200px;
        }
        .go_btn.on ~ .apply_btn {
            display: block;
            margin: 0 auto;
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

    </script>
</head>
<body>

<div class="wrap">
    <header>
        <a href="/index" class="logo">SuperScheduler</a>
        <a href="https://github.com/starry-asterisk/superschedule" class="to_project">project Page</a>
    </header>
    <main>
        <div>
            <button onclick="javascript:go();" class="go_btn">go</button>
            <p class="hint">click this to write a article</p>
            <input type="text" class="input_title">
            <button onclick="javascript:apply();" class="apply_btn">apply</button>
            <textarea class="input_description">
            </textarea>
        </div>
    </main>
    <footer>by <a href="https://github.com/starry-asterisk" style="color:cornflowerblue">@starry-asterisk</a></footer>
</div>
</body>
</html>