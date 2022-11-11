<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page isErrorPage = "true" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <link rel="shortcut icon" href="/img/favicon.ico" type="image/x-icon">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-Zenh87qX5JnK2Jl0vWa8Ck2rdkQ2Bzep5IDxbcnCeuOxjzrPF/et3URy9Bv1WTRi" crossorigin="anonymous">

    <title>${status} Error Page</title>

    <script src="https://code.jquery.com/jquery-3.6.1.slim.js" integrity="sha256-tXm+sa1uzsbFnbXt8GJqsgi2Tw+m4BLGDof6eUPjbtk=" crossorigin="anonymous"></script>
    <script type="text/javascript" src="${rootPath}/js/util/math.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-OERcA2EqjJCMA+/3y+gxIOqMEjwtxJY7qPCqsdltbNJuaOe923+mo//f6V8Qbsw3" crossorigin="anonymous"></script>
    <style>
        h3 {
            display: inline-block;
            margin: 0;
        }
        :root {
            --bg-color: white;
            --font-default-color: black;
            --font-minor-color: lightgray;
            alignment: center;
            align-content: center;
            text-align: center;
        }
        body {
            background-color: var(--bg-color);
        }
        .wrap {
            display: flex;
            flex-direction: column;
            position: relative;
            padding: 16px;
            max-width: 42em;
            width: 100%;
            height: 100vh;
            margin: 0 auto;
        }
        header{
            height: 50px;
            line-height: 50px;
            margin-bottom: auto;
            justify-content: center;
        }
        a, a:visited {
            text-decoration: none;
            color: var(--font-default-color);
        }
        .logo {
            float: left;
            font-size: 2em;
        }
        .to_project {
            float: right;
            color: var(--font-default-color);
            font-size: 1em;
        }

        .logo:hover {
            cursor: pointer;
        }
        main {
        }
        footer{
            height: 50px;
            margin-top: auto;
        }
        .error_code{
            position: relative;
            display: inline-block;
            height: 8rem;
            width: 14rem;
            line-height: 8rem;
            font-size: 8rem;
            font-weight: 600;
        }
        .error_code::after {
            content: attr(code);
            position: absolute;
            height: 65px;
            left: -2px;
            overflow: hidden;
            background-color: var(--bg-color);
        }
        .error_code::before {
            content: attr(code);
            position: absolute;
            left: 0px;
        }
        .detail {
            display: none;
            width: fit-content;
            text-align: left;
        }
        .on + .detail{
            display: block;
        }
        .folding_btn::after{
            cursor: pointer;
            content: "show detail";
        }
        .folding_btn.on::after{
            content: "close detail";
        }
    </style>

</head>
<body>
<div class="wrap">
    <header>
        <a href="/index" class="logo">SuperScheduler</a>
        <a href="/index" class="to_project">project Page</a>
    </header>
    <main>
        <span class="error_code" code="${status}"></span><br>
        <h3>${error}</h3><br>
        <span onClick="$(this).toggleClass('on')" class="folding_btn"></span>
        <pre class="detail">
Requested URL : ${path}
Exception     : ${exception}

==========================================================================

${trace}
        </pre>
    </main>
    <footer>by <a href="https://github.com/starry-asterisk" style="color:cornflowerblue">@starry-asterisk</a></footer>
</div>
</body>
</html>