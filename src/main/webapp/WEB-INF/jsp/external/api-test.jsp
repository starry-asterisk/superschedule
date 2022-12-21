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
    <style>
        main {
            display: flex;
            flex-direction: row;
            height: calc(100vh - 132px);
        }
        ul.rooms_list {
            list-style: none;
            margin: 0;
            padding: 0;
            height: 100%;
            overflow-y: scroll;
            flex: 1;

        }
        ul.rooms_list > li{
            display: flex;
            position: relative;
            font-size: 12px;
            text-align: left;
            padding: 10px;
            border-bottom: 1px solid grey;
            overflow: hidden;

        }
        ul.rooms_list > li > span.title{
            flex: 1;
            overflow: hidden;
            text-align: left;
            white-space: nowrap;
            text-overflow: ellipsis;
        }
        ul.rooms_list > li > span.timestamp{
            color: grey;
            padding-left: 10px;
        }
        div.room_detail {
            display: flex;
            flex-direction: column;
            flex: 2;
        }
        .messages_list{
            display: flex;
            flex-direction: column;
            padding: 10px;
            overflow-y: scroll;
            height: 100%;
            margin: 0;
        }
        .messages_list > span {
            position: relative;
            margin-top: 40px;
            margin-right: auto;
            max-width: 60%;
            padding: 10px;
            border-radius: 5px;
            background-color: #3498DB;
            text-align: left;
            word-break: break-all;
        }
        .messages_list > span > span {
            position: absolute;
            color: grey;
            white-space: nowrap;
        }
        .messages_list > span > span:first-child {
            bottom: 100%;
            margin-bottom: 5px;
            left: 0;
            right: 0;
            text-align: left;
        }
        .messages_list > span > span:last-child {
            bottom: 0;
            left: 100%;
            margin-left: 5px;
            text-align: left;
        }
        .message_form {
            padding: 10px;
            min-height: 70px;
            max-height: 40%;
            display: flex;
            border-top: 1px solid grey;
        }
        .message_form > .message_input {
            word-break: break-all;
            text-align: left;
            max-height: 100%;
            min-height: 50px;
            padding: 10px;
            line-height: 30px;
            overflow-y: auto;
            flex: 1;
        }
        .message_form > .message_submit {
            margin-top: auto;
            margin-left: 10px;
            position: relative;
            width: 40px;
            height: 40px;
            border: 20px;
            background-color: #0a58ca;
        }
    </style>
    <title>SuperScheduler :: API test</title>

    <script src="https://code.jquery.com/jquery-3.6.1.slim.js" integrity="sha256-tXm+sa1uzsbFnbXt8GJqsgi2Tw+m4BLGDof6eUPjbtk=" crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-OERcA2EqjJCMA+/3y+gxIOqMEjwtxJY7qPCqsdltbNJuaOe923+mo//f6V8Qbsw3" crossorigin="anonymous"></script>
    <script type="text/javascript" src="${rootPath}/js/util/default.js"></script>
    <script type="text/javascript" src="${rootPath}/js/util/net.js"></script>
    <script>
        let test = [];
        /*
        * https://developer.webex.com/docs/api/v1/rooms/list-rooms
        *
    {
        "id": "Y2lzY29zcGFyazovL3VzL1JPT00vMWRlYTY4MTAtN2Y2MS0xMWVkLWJmMDUtYzdmOWE3NDlmODA5",
        "title": "박현규",
        "type": "direct",
        "isLocked": false,
        "lastActivity": "2022-12-19T06:54:45.589Z",
        "creatorId": "Y2lzY29zcGFyazovL3VzL1BFT1BMRS84OGQ2NTE2Mi0xMTk3LTRkYzYtOTA0ZC1hOTk5NGFhN2U4ZGQ",
        "created": "2022-12-19T05:51:00.881Z",
        "ownerId": "Y2lzY29zcGFyazovL3VzL09SR0FOSVpBVElPTi9lZWE4OGQxYS0zNmNlLTQ1MzYtODEzOC04ZGI1Mjc5MmRiZjM",
        "isPublic": false,
        "isReadOnly": false
    },
        *
        */
        const WEBEX_ACCESS_TOKEN = 'YTI1N2UwZmEtODI1Mi00N2E4LWI5ZWYtMTQ3ZjQ3MWI5NjMxZDNiY2UzNmYtZTI5_PF84_eea88d1a-36ce-4536-8138-8db52792dbf3';
        const url = {
            rooms: 'https://webexapis.com/v1/rooms',
            messages: 'https://webexapis.com/v1/messages',
        };
        const data = {
            rooms: [],
            messages: [],
        }
        const render = {
            rooms: () => {
                const rooms_list = document.querySelector('.rooms_list')

                while (rooms_list.firstChild) rooms_list.firstChild.remove();

                data.rooms.sort((a, b) => new Date(b.lastActivity) - new Date(a.lastActivity)).forEach(room => {
                    let li = document.createElement('li');
                    li.setAttribute('roomId', room.id);
                    li.setAttribute('type', room.type);
                    li.addEventListener('click', () => {get_messages_list(room.id)});

                    let title = document.createElement('span');
                    title.classList.add('title');
                    title.innerHTML = room.title;
                    li.appendChild(title);

                    let timestamp = document.createElement('span');
                    timestamp.classList.add('timestamp');
                    timestamp.innerHTML = getDateStr(new Date(room.lastActivity));
                    li.appendChild(timestamp);

                    rooms_list.appendChild(li);
                });
            },
            messages: args => {
                if(args){
                    return one_message(args);
                }

                const messages_list = document.querySelector('.messages_list')

                while (messages_list.firstChild) messages_list.firstChild.remove();

                data.messages.forEach(one_message);

                function one_message(arg){
                    let owner = document.createElement('span');
                    let timestamp = document.createElement('span');
                    let text = document.createElement('span');
                    owner.innerHTML = arg.personEmail;
                    timestamp.innerHTML = getDateStr(new Date(arg.created));
                    if(arg.text){
                        text.innerHTML = arg.text;
                    }
                    if(arg.files){
                        arg.files.forEach(link => {
                            let a = document.createElement('a');
                            a.href = link;
                            text.appendChild(a);
                            ajaxHead(link, {}, {Authorization: `Bearer \${WEBEX_ACCESS_TOKEN}`})
                                .then((res) => {
                                    if(res.status !== 200){
                                        return toast(res.message, TOAST_LONG);
                                    }
                                    a.innerHTML = `[ \${res.headers.get('content-Type')} : \${decodeURI(res.headers.get('content-Disposition').split('\"')[1])} ]`;
                                    test.push(res.headers);
                                });
                        })
                    }
                    text.prepend(owner);
                    text.appendChild(timestamp);
                    messages_list.appendChild(text);
                }
            }
        }

        function get_rooms_list(){
            ajaxGet(url.rooms, {}, {Authorization: `Bearer \${WEBEX_ACCESS_TOKEN}`})
                .then((res) => {
                    if(res.error){
                        return toast(res.message, TOAST_LONG);
                    }
                    data.rooms = res.items;
                    render.rooms();
                });
        }

        function get_messages_list(roomId){
            ajaxGet(url.messages, {roomId: roomId}, {Authorization: `Bearer \${WEBEX_ACCESS_TOKEN}`})
                .then((res) => {
                    if(res.error){
                        return toast(res.message, TOAST_LONG);
                    }
                    data.messages = res.items;
                    render.messages();
                });
        }

        function valid_length(s){

            return getByteLength(s) < 7266;

            function getByteLength(s,b,i,c){
                for(b=i=0;c=s.charCodeAt(i++);b+=c>>11?3:c>>7?2:1);
                return b;
            }
        }

        get_rooms_list();
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
    </header>
    <main>
        <ul class="rooms_list">

        </ul>
        <div class="room_detail">
            <ul class="messages_list">

            </ul>
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