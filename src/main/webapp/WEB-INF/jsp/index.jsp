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
            if(loginData){
                $('.go_btn').toggleClass('on');
                $('.input_title').focus();
            }else{
                toast('로그인을 진행 해주셔야 진행 가능한 기능입니다',TOAST_LONG);
            }
        }
        function apply(){
            $('.apply_btn').toggleClass('on');
            $('.input_title').prop('disabled', true);
        }
        function upload(){
            $('.input_description').prop('disabled', true);
            $('.upload_btn').prop('disabled',true);
            $('.loading').show();
            ajax('/boards', {
                title: getDbStr($('.input_title').val()),
                description: getDbStr($('.input_description').val())
            },'POST').then((data) => {
                $('.loading').hide();
                if(data.result){
                    location.reload()
                }else{
                    toast('게시글 작성에 실패했습니다.',TOAST_LONG);
                }
            });
        }
        function list(){
            $('.loading').show();
            ajaxGet('/boards', {}).then((data) => {
                let wrap = document.createElement("div");
                let user_name = loginData!=null?loginData.name:null;
                data.result.forEach(
                    li => {
                        wrap.innerHTML =
                            `<div class="li\${li.author==user_name?' my':''}" data-id="\${li.id}">`+
                            `<svg>`+
                            `<rect height="100%" width="100%"/>`+
                            `</svg>`+
                            `<div class="level" value="\${li.danger_level}"></div>`+
                            `<div class="title">\${getDbStr(li.title, false)}</div>`+
                            `<div class="author_nickname">\${li.author_nickname}</div>`+
                            `<div class="li_detail">`+
                            `<div class="info_bar">`+
                            `<button data-id="\${li.id}" class="board_del" icon="🔥" title="삭제"></button>`+
                            `<button data-id="\${li.id}" class="board_edit" icon="🔧" title="수정"></button>`+
                            `<button data-id="\${li.id}" class="board_reply" icon="💬" title="댓글로 이동"></button>`+
                            `<div class="created">\${new Date(li.created).toLocaleString()}</div>`+
                            `</div>`+
                            `<pre class="contents">\${getDbStr(li.contents, false)}</pre>`+
                            `</div>`+
                            `</div>`;
                        $('.board_list').append($(wrap).children());
                    }
                );
                $('.board_list').addClass("on");
                if(data.result.length < 1){
                    $('.board_list').addClass("empty");
                }
                $('.loading').hide();
            });
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
        $(document).on('click','.board_list .li .title', e => {$(e.target).parent().toggleClass("on");});

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
        <div class="board_list"></div>
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