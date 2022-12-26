<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <link rel="shortcut icon" href="/img/favicon.ico" type="image/x-icon">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-Zenh87qX5JnK2Jl0vWa8Ck2rdkQ2Bzep5IDxbcnCeuOxjzrPF/et3URy9Bv1WTRi" crossorigin="anonymous">
    <link href="${rootPath}/css/theme.css" rel="stylesheet">
    <link href="${rootPath}/css/common.css" rel="stylesheet">
    <style>
        main {
            display: flex;
            flex-direction: row;
            height: calc(100vh - 132px);
            border: 1px solid grey;
        }
        ul.rooms_list {
            list-style: none;
            margin: 0;
            padding: 0;
            height: 100%;
            overflow-y: scroll;
            flex: 1;
            max-width: 20rem;
            border-right: 1px solid grey;
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
            overflow-x: hidden;
            height: 100%;
            margin: 0;
        }
        .messages_list > span {
            position: relative;
            margin-top: 40px;
            margin-left: 50px;
            margin-right: auto;
            max-width: 80%;
            padding: 10px;
            border-radius: 5px;
            background-color: var(--bg-color2);
            text-align: left;
            word-break: break-all;
            box-shadow: 2px 5px 10px 0 var(--default-color-1of10);
        }
        .messages_list > span.me {
            margin-right: 50px;
            margin-left: auto;
            background-color: var(--font-minor-color);
        }
        .messages_list > span > img {
            position: absolute;
            width: 40px;
            height: 40px;
            object-fit: cover;
            object-position: center;
            border-radius: 20px;
            bottom: calc(100% - 15px);
            right: calc(100% + 5px);
        }
        .messages_list > span > img::after {
            content: attr(alt);
            display: block;
            position: absolute;
            top: 0;
            left: 0;
            width: 40px;
            height: 40px;
            background-color: var(--bg-color2);
            color: var(--default-color);
            font-weight: 600;
            line-height: 40px;
            text-align: center;
        }
        .messages_list > span.me > img {
            right: auto;
            left: calc(100% + 5px);
        }

        .messages_list > span > img.content_img {
            position: relative;
            width: 100%;
            height: auto;
            right: auto;
            left: auto;
            bottom: auto;
            border-radius: 5px;
            margin-top: 10px;
        }
        .messages_list > span > img.content_img.full_screen {
            z-index: 9999;
            position: fixed;
            max-width: 50%;
            max-height: 100%;
            margin: auto;
            top: 0;
            left: 0;
            bottom: 0;
            right: 0;
            border-radius: 0;
            box-shadow: 0 0 0 10000px rgb(0 0 0 / 50%);
        }
        .messages_list > span > span {
            position: absolute;
            color: grey;
            white-space: nowrap;
        }
        .messages_list > span > span:first-of-type {
            bottom: 100%;
            margin-bottom: 5px;
            left: 0;
            right: auto;
            text-align: left;
        }
        .messages_list > span.me > span:last-of-type {
            left: auto;
            right: 100%;
            margin-left: 0;
            margin-right: 5px;
            text-align: right;
        }
        .messages_list > span.me > span:first-of-type {
            bottom: 100%;
            margin-bottom: 5px;
            left: auto;
            right: 0;
            text-align: right;
        }
        .messages_list > span > span:last-of-type {
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
        }
        .message_form > .message_submit::after {
            content: '\F6C0';
            font-family: bootstrap-icons;
            font-weight: 600;
        }
    </style>
    <title>SuperScheduler :: API test</title>

    <script src="https://code.jquery.com/jquery-3.6.1.slim.js" integrity="sha256-tXm+sa1uzsbFnbXt8GJqsgi2Tw+m4BLGDof6eUPjbtk=" crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-OERcA2EqjJCMA+/3y+gxIOqMEjwtxJY7qPCqsdltbNJuaOe923+mo//f6V8Qbsw3" crossorigin="anonymous"></script>
    <script type="text/javascript" src="${rootPath}/js/util/default.js"></script>
    <script type="text/javascript" src="${rootPath}/js/util/net.js"></script>
    <script type="text/javascript" src="${rootPath}/js/lib/webex-bundle.js"></script>
    <script>
        const WEBEX_ACCESS_TOKEN = '${access_token}';
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
                        beforeMessage = null;
                        message_top_reached = false;
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
            messages: (args, reverse = false, autoScroll= true) => {
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
                    let avatar = document.createElement('img');
                    timestamp.innerHTML = getDateStr(new Date(arg.created));
                    let person = data.peoples[arg.personId];
                    if(person){
                        owner.innerHTML = person.displayName;
                        avatar.setAttribute('alt',person.displayName[0]);
                        if(person.avatar) avatar.src = person.avatar;
                    }else{
                        owner.innerHTML = arg.personEmail;
                        avatar.setAttribute('alt',arg.personEmail[0]);
                    }

                    if(arg.personId === tokenHolder.id) text.classList.add('me');

                    if(arg.text) text.innerHTML = arg.text;
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

                                    if(res.headers.get('content-Type').indexOf('image') > -1){
                                        fetch(res.url, {
                                            method: "GET", // *GET, POST, PUT, DELETE 등
                                            mode: 'cors', // this cannot be 'no-cors'
                                            headers: {
                                                Authorization: `Bearer \${WEBEX_ACCESS_TOKEN}`,
                                            }
                                        })
                                            .then(imageRes => imageRes.blob())
                                            .then((imageBlob) => {
                                                let img = document.createElement('img');
                                                const imageBlob64 = URL.createObjectURL(imageBlob);
                                                img.src = imageBlob64;
                                                img.classList.add('content_img');
                                                $(a).replaceWith(img);
                                            });
                                    }else{
                                        a.innerHTML = `[ \${res.headers.get('content-Type')} : \${decodeURI(res.headers.get('content-Disposition').split('\"')[1])} ]`;
                                    }
                                });
                        })
                    }
                    text.appendChild(avatar);
                    text.appendChild(owner);
                    text.appendChild(timestamp);
                    text.tabIndex = -1;
                    if(reverse){
                        messages_list.appendChild(text);
                    }else{
                        messages_list.prepend(text);
                    }
                    if(autoScroll) {
                        messages_list.scrollTop = messages_list.scrollHeight
                    }
                    return {wrap: text, namespace: owner, timestamp: timestamp, avatar: avatar};
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

        $(document).on('click', 'img.content_img ', e => e.target.classList.toggle('full_screen'));

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
                    data.rooms = res.items;
                    render.rooms();
                })
                .catch(error_handler);
        }

        let beforeMessage = null;
        let message_top_reached = false;
        const MESSAGES_MAX = 50;

        function listUpMessages(room_id){

            if(message_top_reached) return toast("모든 메시지를 확인 하셨습니다.");

            if(beforeMessage === null) {
                render.messages(false);
                data.messages.now_presented = room_id;
                if(!data.messages[room_id]){
                    data.messages[room_id] = [];
                }else if(data.messages[room_id].length > 0){
                    beforeMessage = data.messages[room_id][data.messages[room_id].length - 1].id;
                    return data.messages[room_id].forEach(el => render.messages(el));
                }
            }

            let param = {
                roomId: room_id,
                max: MESSAGES_MAX
            };

            if(beforeMessage) param.beforeMessage = beforeMessage;

            webex.messages.list(param)
                .then(res =>{
                    res.items.forEach(item => {
                        if(data.peoples[item.personId]){
                            display_message();
                        }else{
                            let el = display_message();
                            webex.people.get(item.personId).then(
                                sender => {
                                    data.peoples[sender.id] = sender;
                                    el.namespace.innerHTML = sender.displayName;
                                    el.avatar.setAttribute('alt',sender.displayName[0]);
                                    if(sender.avatar) el.avatar.src = sender.avatar;
                                }
                            ).catch(error_handler);
                        }

                        function display_message(){
                            data.messages[room_id].push(item);
                            return render.messages(item, false, !beforeMessage);
                        }
                    });

                    beforeMessage = res.items[res.items.length - 1].id;

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

            $('.messages_list').on('scroll', e => {
                if(e.target.scrollTop <= 0) listUpMessages(data.messages.now_presented);
            })
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