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
            position: relative;
            font-size: 12px;
            text-align: left;
            padding: 10px;
            border-bottom: 1px solid grey;
            overflow: hidden;
        }
        ul.rooms_list > li > span{
            position: absolute;
            right: 10px;
            color: grey;
            background: var(--bg-color);
        }
        div.room_detail {
            overflow-y: scroll;
            flex: 2;
        }
    </style>
    <title>SuperScheduler :: API test</title>

    <script src="https://code.jquery.com/jquery-3.6.1.slim.js" integrity="sha256-tXm+sa1uzsbFnbXt8GJqsgi2Tw+m4BLGDof6eUPjbtk=" crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-OERcA2EqjJCMA+/3y+gxIOqMEjwtxJY7qPCqsdltbNJuaOe923+mo//f6V8Qbsw3" crossorigin="anonymous"></script>
    <script type="text/javascript" src="${rootPath}/js/util/default.js"></script>
    <script type="text/javascript" src="${rootPath}/js/util/net.js"></script>
    <script>
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
        const WEBEX_ACCESS_TOKEN = 'NTg5NzI2YjgtZmZlZi00YWVlLWFmYjYtN2NmZjY5Nzc2MWE3ZGZlYjkyNDQtN2Rm_PF84_eea88d1a-36ce-4536-8138-8db52792dbf3';
        const url = {
            rooms: 'https://webexapis.com/v1/rooms'
        };
        const data = {
            rooms: [],
        }
        const render = {
            rooms: () => {
                data.rooms.sort((a, b) => new Date(a.lastActivity) > new Date(b.lastActivity)).forEach(room => {
                    let li = document.createElement('li');
                    li.setAttribute('room_id', room.id);
                    li.setAttribute('type', room.type);
                    li.innerHTML = room.title;
                    let span = document.createElement('span');
                    span.innerHTML = getDateStr(new Date(room.lastActivity));
                    li.appendChild(span);
                    document.querySelector('.rooms_list').appendChild(li);
                });
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

        </div>
    </main>
    <footer>by <a href="https://github.com/starry-asterisk" style="color:cornflowerblue">@starry-asterisk</a></footer>
</div>
</body>
</html>