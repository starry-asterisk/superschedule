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
            max-width: 20rem;

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
        ul.rooms_list > li:hover {
            background-color: rgba(0,0,0,0.1);
            cursor: pointer;
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
    <script type="text/javascript" src="${rootPath}/js/lib/webex-bundle.js"></script>
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
        const WEBEX_ACCESS_TOKEN = 'MjhhY2M3ZjItODFkOC00NDZkLWE4ZWQtYjE5YjU1MDFiZmJlZjhiMjc0M2YtZDRk_PF84_eea88d1a-36ce-4536-8138-8db52792dbf3';
        const data = {
            rooms: [],
            messages: {now_presented: null},
            peoples: {}
        }
        const render = {
            rooms: args => {

                const rooms_list = document.querySelector('.rooms_list');

                if(args){
                    return one_room(args);
                }

                while (rooms_list.firstChild) rooms_list.firstChild.remove();

                if(args !== false) data.rooms.sort((a, b) => new Date(b.lastActivity) - new Date(a.lastActivity)).forEach(one_room);

                function one_room(room){
                    let li = document.createElement('li');
                    li.setAttribute('roomId', room.id);
                    li.setAttribute('type', room.type);
                    li.addEventListener('click', () => {
                        beforeMessages = null;
                        message_top_reached = null;
                        listUpMessages(room.id)
                    });

                    let title = document.createElement('span');
                    title.classList.add('title');
                    title.innerHTML = room.title;
                    li.appendChild(title);

                    let timestamp = document.createElement('span');
                    timestamp.classList.add('timestamp');
                    timestamp.innerHTML = getDateStr(new Date(room.lastActivity));
                    li.appendChild(timestamp);

                    rooms_list.appendChild(li);
                }
            },
            messages: (args, reversed) => {
                loaded_current = new Date();

                const messages_list = document.querySelector('.messages_list');

                if(args){
                    return one_message(args);
                }

                while (messages_list.firstChild) messages_list.firstChild.remove();

                if(args !== false) data.messages[data.messages.now_presented].forEach(one_message);

                function one_message(arg){
                    let owner = document.createElement('span');
                    let timestamp = document.createElement('span');
                    let text = document.createElement('span');
                    owner.innerHTML = arg.personName;
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
                                });
                        })
                    }
                    text.prepend(owner);
                    text.appendChild(timestamp);
                    if(reversed === true){
                        messages_list.prepend(text);
                    }else{
                        messages_list.appendChild(text);
                    }
                }
            }
        }


        function valid_length(s){

            return getByteLength(s) < 7266;

            function getByteLength(s,b,i,c){
                for(b=i=0;c=s.charCodeAt(i++);b+=c>>11?3:c>>7?2:1);
                return b;
            }
        }


        const Webex = window.webex;

        //globals

        /**
         * @type RoomObject
         * */
        let testRoom;

        /**
         * @type Webex
         * */
        let webex;

        /**
         * Set during authentication and
         * used when updating test room details.
         *
         * @type PersonObject
         * */
        let tokenHolder;

        /**
         * Creates an instance of webex, with the access token provided,
         * however it just creates the object, does not verify if the
         * provided token is valid.
         * */
        function initialize() {

            webex = Webex.init({
                credentials: {
                    access_token: WEBEX_ACCESS_TOKEN
                }
            });

        }

        /**
         * Handles pushing the Send Random Message button,
         * by posting a random unicode emoji from a message pool.
         * */

        $(document).on('click', '.message_submit', () => {
            if(data.messages.now_presented && $('.message_input')[0].innerHTML){
                webex.messages.create({
                    roomId: data.messages.now_presented,
                    markdown: $('.message_input')[0].innerHTML
                }).then(() => {
                    $('.message_input')[0].innerHTML = '';
                }).catch(error_handler);
            }else{
                toast('열려있는 채팅방이나 작성하신 채팅이 없습니다.');
            }
        });

        /**
         * Starts a websocket, that will listen for incoming messages. The process is
         * similar to creating a webhook with 'resource' and 'event', here the resource
         * is defined by the webex.messages.listen() function, while the event is
         * specified by the webex.messages.on() function.
         * */
        function listenToMessages() {

            //creating the websocket listener with 'messages' resource...
            webex.messages.listen().then(() => {

                //...and 'created' event
                webex.messages.on('created', (event) => {

                    //getting the details of the message sender to update the UI

                    if(data.peoples[event.actorId]){
                        display_message(data.peoples[event.actorId]);
                    }else{
                        webex.people.get(event.actorId).then(sender => {
                            data.peoples[event.actorId] = sender;
                            display_message(sender);
                        }).catch(error_handler);
                    }


                    function display_message(sender){
                        event.data.personName = sender.displayName;
                        if(data.messages[event.data.roomId]) data.messages[event.data.roomId].unshift(event.data);
                        if(data.messages.now_presented === event.data.roomId) render.messages(event.data, true);
                        //getting the details of the room the message was posted in
                        webex.rooms.get(event.data.roomId).then(
                            room => {
                                //update UI
                                //dateToDisplay;
                                toast(`\${sender.displayName}님 이 보낸 메시지: \${event.data.text} - \${room.title}`);
                            }
                        ).catch(error_handler);
                    }
                });

            }).catch(error_handler);
        }

        function listUpRooms(){
            webex.rooms.list({max: 1000})
                .then(res => {
                    res.items.sort((a, b) => new Date(b.lastActivityDate) - new Date(a.lastActivityDate)).forEach(render.rooms);
                })
                .catch(error_handler);
        }

        let beforeMessages = null;
        let message_top_reached = false;
        const MESSAGES_MAX = 50;

        function listUpMessages(room_id){

            if(message_top_reached) return toast("모든 메시지를 확인 하셨습니다.");

            if(beforeMessages === null) {
                render.messages(false);
                data.messages.now_presented = room_id;
                if(!data.messages[room_id]){
                    data.messages[room_id] = [];
                }else{
                    beforeMessages = data.messages[room_id][data.messages[room_id].length - 1].id;
                    return data.messages[room_id].forEach(render.messages);
                }
            }

            let param = {
                roomId: room_id,
                max: MESSAGES_MAX
            };

            if(beforeMessages) param.beforeMessages = beforeMessages;

            webex.messages.list(param)
                .then(res =>{
                    res.items.forEach(item => {
                        if(data.peoples[item.personId]){
                            display_message(data.peoples[item.personId]);
                        }else{
                            webex.people.get(item.personId).then(
                                sender => {
                                    data.peoples[item.personId] = sender;
                                    display_message(sender);
                                }
                            ).catch(error_handler);
                        }

                        function display_message(sender_info){
                            item.personName = sender_info.displayName;
                            data.messages[room_id].push(item);
                            render.messages(item);
                        }
                    });

                    beforeMessages = res.items[res.items.length - 1].id;

                    if(res.items.length < MESSAGES_MAX) message_top_reached = true;
                }).catch(error_handler);

        }

        function error_handler(e){
            toast(e.message, TOAST_LONG);
        }

        $(document).ready(() => {

            //initialize the webex object
            initialize();

            //makes a call to /people/me to verify that the passed access-token is valid
            //if it is, shows further options, like 'Listen to messages',... are activated
            webex.people.get('me').then(person => {

                //access token is verified

                tokenHolder = person;

                //show further options
                listUpRooms();
                listenToMessages();

            }).catch(error_handler);
        });






        /**
         * Creates a test room, so the user can trigger messages from the app.
         * */
        function createRoom() {

            webex.rooms.create({title: 'WebSocket Test Room'}).then(room => {

                testRoom = room;
                let date = new Date(Date.parse(room.created));

                //show test room table
                document.getElementById('room-wrapper').style.display = 'inline';
                document.getElementById('messages-btn').style.display = 'inline';

                //update test room table
                document.getElementById('room-table-title').innerHTML = room.title;
                document.getElementById('room-table-created-by').innerHTML = tokenHolder.displayName;
                document.getElementById('room-table-created-at').innerHTML = date.toTimeString().split(' ')[0];

                //change button text
                document.getElementById('room-btn').innerHTML = 'Delete Test Room';

            }).catch(error_handler);

        }

        /**
         * Deletes the created test room.
         * */
        function clearRoom() {

            webex.rooms.remove(testRoom).then(() => {
                testRoom = undefined;

                //hide room table
                document.getElementById('room-wrapper').style.display = 'none';
                document.getElementById('messages-btn').style.display = 'none';

                //clear room table
                document.getElementById('room-table-title').innerHTML = '';
                document.getElementById('room-table-created-by').innerHTML = '';
                document.getElementById('room-table-created-at').innerHTML = '';

                //change button text
                document.getElementById('room-btn').innerHTML = 'Create Test Room';


            }).catch(error_handler);

        }
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