
import mime from '/js/json/mime.json' assert { type: 'json' };

const data = {
    rooms: [],
    messages: {now_presented: null},
    peoples: {},
}
const render = {
    rooms: filter => {

        render_temp.presented_filter = filter;

        const rooms_list = document.querySelector('.rooms_list');

        while (rooms_list.firstChild) rooms_list.firstChild.remove();

        let rooms = data.rooms;

        switch (filter){
            case 'direct':
                rooms = rooms.filter(room => room.type === 'direct');
                break;
            case 'space':
                rooms = rooms.filter(room => room.type === 'group');
                break;
            default:
                rooms = rooms.filter(room => room.title.indexOf(filter) > -1);
                break;
            case 'all':
            case undefined:
            case null:
            case NaN:
            case '':
            case []:
                break;
        }

        rooms.sort((a, b) => new Date(b.lastActivity) - new Date(a.lastActivity)).forEach(one_room);

        function one_room(room){
            let li = document.createElement('li');
            li.setAttribute('roomId', room.id);
            li.setAttribute('type', room.type);
            li.addEventListener('click', () => {
                beforeMessage = null;
                message_top_reached = false;
                render_temp.thread_stack = [];
                render_temp.scroll.height = 0;
                listUpMessages(room.id);

                room.unchecked = undefined;
                document.querySelector('.room_title').innerHTML = room.title;
                render.rooms(render_temp.presented_filter);
            });

            let title = document.createElement('span');
            title.classList.add('title');
            title.innerHTML = room.title;
            if(room.unchecked) title.setAttribute('data-count', room.unchecked);
            li.appendChild(title);

            let timestamp = document.createElement('span');
            timestamp.classList.add('timestamp');
            timestamp.innerHTML = getDateStr(new Date(room.lastActivity));
            li.appendChild(timestamp);

            if(data.messages.now_presented === room.id) li.classList.add('selected');
            rooms_list.appendChild(li);
        }
    },
    messages: (args = data.messages[data.messages.now_presented], reverse = false, autoScroll= true) => {
        loaded_current = new Date();

        const messages_list_wrap = document.querySelector('.messages_list_wrap');
        const messages_list = messages_list_wrap.querySelector('.messages_list');
        render_temp.scroll.height = messages_list_wrap.scrollHeight;

        if(reverse) return one_message(args);

        if(autoScroll) while (messages_list.firstChild) messages_list.firstChild.remove();

        args.forEach(one_message);

        for(let index = render_temp.thread_stack.length - 1;index > -1;index--){
            let thread = render_temp.thread_stack[index];
            let parent = document.querySelector(`[data-messageId=${thread.key}]`);
            if(parent) {
                while(parent.nextElementSibling && parent.nextElementSibling.classList.contains('thread')) parent = parent.nextElementSibling;
                parent.after(thread.el);
                render_temp.thread_stack.splice(index, 1);
            }
        }

        scroll();

        function scroll(){
            if(autoScroll) {
                messages_list_wrap.scrollTop = messages_list_wrap.scrollHeight;
            } else if(!reverse){
                messages_list_wrap.scrollTop = messages_list_wrap.scrollHeight - render_temp.scroll.height;
            }
        }

        function one_message(arg, index){
            let owner = document.createElement('span');
            let text = document.createElement('span');
            let avatar = document.createElement('img');

            text.setAttribute('data-messageId', arg.id);

            if(arg.personId === tokenHolder.id) text.classList.add('me');

            if(arg.text) text.innerHTML = arg.html || renderLinkInText(arg.markdown || arg.text);

            text.querySelectorAll('img:not(.avatar)').forEach(el => el.classList.add('content_img'));

            if(arg.files){
                arg.files.forEach(link => {
                    let a = document.createElement('a');
                    a.href = link;
                    text.appendChild(a);
                    ajaxHead(link, {}, {Authorization: `Bearer ${WEBEX_ACCESS_TOKEN}`})
                        .then((res) => {
                            if(res.status !== 200){
                                return toast(res.message, TOAST_LONG);
                            }

                            let contentType = res.headers.get('content-Type');

                            if(contentType.indexOf('image') > -1){
                                fetch(res.url, {
                                    method: "GET", // *GET, POST, PUT, DELETE 등
                                    mode: 'cors', // this cannot be 'no-cors'
                                    headers: {
                                        Authorization: `Bearer ${WEBEX_ACCESS_TOKEN}`,
                                    }
                                })
                                    .then(imageRes => imageRes.blob())
                                    .then((imageBlob) => {
                                        let img = document.createElement('img');
                                        const imageBlob64 = URL.createObjectURL(imageBlob);
                                        img.src = imageBlob64;
                                        img.onload = () => {
                                            URL.revokeObjectURL(imageBlob64);
                                            scroll();
                                        }
                                        img.classList.add('content_img');
                                        $(a).replaceWith(img);
                                    });
                            }else{
                                a.innerHTML = decodeURI(res.headers.get('content-Disposition').split('\"')[1]);
                                a.classList.add('content_file');
                                let mime_img = document.createElement('img');
                                mime_img.src = '/img' + ( mime[contentType] ? mime[contentType][3] : '/mime/file.png' );
                                mime_img.classList.add('mime');
                                mime_img.onload = scroll;
                                a.prepend(mime_img);
                            }
                        });
                })
            }

            if(arg.parentId) {
                text.classList.add('thread');
                return addProfileInfo(true);
            }

            let now_timestamp;
            let next_timestamp;

            if(!reverse && args.length !== index + 1){
                let next = args[index + 1];
                now_timestamp = Math.floor(new Date(arg.created).getTime() / 60000);
                next_timestamp = Math.floor(new Date(next.created).getTime() / 60000);
                if(next.personId === arg.personId && next_timestamp === now_timestamp) return final();
            }

            addProfileInfo();

            function addProfileInfo(ignoreSeparator = false){

                let person = data.peoples[arg.personId];
                if(person){
                    owner.setAttribute('data-name', person.displayName);
                    avatar.setAttribute('alt',person.displayName[0]);
                    if(person.avatar) avatar.src = person.avatar;
                }else{
                    owner.setAttribute('data-name', arg.personEmail);
                    avatar.setAttribute('alt',arg.personEmail[0]);
                    if (!render_temp.lazy_load_info_queue[arg.personId]) {
                        render_temp.lazy_load_info_queue[arg.personId] = [{owner: owner, avatar: avatar}];
                        webex.people.get(arg.personId).then(
                            sender => {
                                data.peoples[sender.id] = sender;
                                render_temp.lazy_load_info_queue[arg.personId].forEach(el => {
                                    el.owner.setAttribute('data-name', sender.displayName);
                                    el.avatar.setAttribute('alt', sender.displayName[0]);
                                    if (sender.avatar) el.avatar.src = sender.avatar;
                                });
                                render_temp.lazy_load_info_queue[arg.personId] = undefined;
                            }
                        ).catch(error_handler);
                    } else {
                        render_temp.lazy_load_info_queue[arg.personId].push({owner: owner, avatar: avatar});
                    }
                }

                avatar.classList.add('avatar')
                if(!render_temp.name_color[arg.personId]) render_temp.name_color[arg.personId] = randomColor();
                owner.style.color = '#' + render_temp.name_color[arg.personId];
                let timestamp = document.createElement('span');
                timestamp.innerHTML = getDateStr(new Date(arg.created));
                owner.appendChild(timestamp);
                text.appendChild(owner);
                text.appendChild(avatar);

                final(true, ignoreSeparator);

                if(ignoreSeparator) return;

                now_timestamp = Math.floor(now_timestamp / 1440);
                next_timestamp = Math.floor(next_timestamp / 1440);

                if(next_timestamp !== now_timestamp) addSeparator();
            }

            function addSeparator(){
                let separator = document.createElement('p');
                let date = new Date(arg.created);
                separator.innerHTML = date.getFullYear()+'년 '+(date.getMonth() + 1)+'월 '+date.getDate()+'일';
                if(!reverse){
                    messages_list.prepend(separator);
                }
            }

            function final(marginTop = false, isThread = false){
                text.tabIndex = -1;
                if(!marginTop) text.style.marginTop = 0;
                if(isThread){
                    let parent = document.querySelector(`[data-messageId=${arg.parentId}]`);
                    if(parent)  {
                        while(parent.nextElementSibling && parent.nextElementSibling.classList.contains('thread')) parent = parent.nextElementSibling;
                        parent.after(text);
                    }
                    else render_temp.thread_stack.push({key: arg.parentId, el: text});
                }else if(reverse){
                    messages_list.appendChild(text);
                }else{
                    messages_list.prepend(text);
                }
            }
        }
    }
}
const render_temp = {
    presented_filter: 'all',
    name_color: {},
    lazy_load_info_queue: {},
    thread_stack: [],
    scroll: {
        height: 0
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

$(document).on('click', 'img.content_img', e => e.target.classList.toggle('full_screen'));

/**
 * Starts a websocket, that will listen for incoming messages. The process is
 * similar to creating a webhook with 'resource' and 'event', here the resource
 * is defined by the webex.messages.listen() function, while the event is
 * specified by the webex.messages.on() function.
 * */
function listenToMessages() {

    //creating the websocket listener with 'messages' resource...
    webex.messages.listen().then(e => {

        webex.messages.on('deleted', (event) => {
            //삭제 이벤트 시 대응 방안
            const del_data = event.data;
            document.querySelector(`[data-messageid=${del_data.id}]`).remove();
            for(let i in data.messages[del_data.roomId]) if(data.messages[del_data.roomId][i].id === del_data.id) {data.messages[del_data.roomId].splice(i, 1);break;}
        });
        //...and 'created' event
        webex.messages.on('created', (event) => {

            webex.messages.get(event.data.id).then(res => {

                //getting the details of the message sender to update the UI

                if(data.peoples[res.personId]){
                    display_message(data.peoples[res.personId]);
                }else{
                    webex.people.get(res.personId).then(sender => {
                        data.peoples[res.personId] = sender;
                        display_message(sender);
                    }).catch(error_handler);
                }

                async function display_message(sender){
                    if(data.messages[res.roomId]) data.messages[res.roomId].unshift(res);

                    let room = data.rooms.find(room => res.roomId === room.id);

                    if(room) {
                        room.lastActivity = res.created;
                    }else {
                        room = await webex.rooms.get(res.roomId);
                        data.rooms.push(room);
                    }

                    if(data.messages.now_presented === res.roomId) {
                        render.messages(res, true);
                    } else {
                        if(room.unchecked){
                            room.unchecked++;
                        } else {
                            room.unchecked = 1;
                        }
                    }

                    render.rooms(render_temp.presented_filter);

                    if (Notification.permission !== 'granted') {
                        toast(`${sender.displayName}님 이 보낸 메시지: ${res.text?res.text:'(파일 또는 사진)'} - ${room.title}`);
                    } else {
                        const notification = new Notification(`${room.title}`, {
                            icon: `${rootPath}/img/icon.png`,
                            body: `${sender.displayName} : ${res.text?res.text:'(파일 또는 사진)'}`,
                        });

                        notification.onclick = function () {
                            window.focus();
                        };
                    }
                }
            }).catch(error_handler);
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

    if(!room_id) return;

    if(message_top_reached) return toast("모든 메시지를 확인 하셨습니다.");

    if(beforeMessage === null) {
        data.messages.now_presented = room_id;
        if(!data.messages[room_id]){
            data.messages[room_id] = [];
        }else if(data.messages[room_id].length > 0){
            beforeMessage = data.messages[room_id][data.messages[room_id].length - 1].id;
            return render.messages();
        }
    }

    let param = {
        roomId: room_id,
        max: MESSAGES_MAX
    };

    if(beforeMessage) param.beforeMessage = beforeMessage;

    webex.messages.list(param)
        .then(res =>{
            if(res.items.length > 0){
                res.items.forEach(item => data.messages[room_id].push(item));

                render.messages(res.items, false, !beforeMessage);

                beforeMessage = res.items[res.items.length - 1].id;
            }
            if(res.items.length < MESSAGES_MAX) message_top_reached = true;
        }).catch(error_handler);

}

function error_handler(e){
    console.error(e);
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

    $('.messages_list_wrap').on('scroll', e => e.target.scrollTop <= 0 && listUpMessages(data.messages.now_presented))

    $(document).on('click', 'input[name=room_type]', e => render.rooms(e.target.value));

    $(document).on('keydown', '.message_input', e => {if(e.key === 'Enter' && !e.shiftKey) {e.preventDefault();document.querySelector('.message_submit').click();}});

    if (window.Notification && Notification.permission === 'default') {
        Notification.requestPermission();
    }

    let resizeObserver = new ResizeObserver((entries) => {
        for (const entry of entries) {
            let target = entry.target;
            let parent = target.parentElement;
            let thumb = parent.querySelector('.custom-scrollbar');
            let scrollHeight;
            let scrollTop;
            let clientHeight;

            parent.onscroll = updateThumb;

            thumb.onmousedown = mousedownThumb;

            parent.onscroll();

            function updateThumb() {
                thumb.style.setProperty('display', 'none');
                scrollHeight = target.scrollHeight;
                scrollTop = parent.scrollTop;
                clientHeight = parent.getClientRects()[0].height;
                if(clientHeight / scrollHeight < 1){
                    thumb.style.removeProperty('display');
                    thumb.style.setProperty('top', scrollTop + (scrollTop / scrollHeight * clientHeight) + 'px');
                    thumb.style.setProperty('height', clientHeight / scrollHeight * 100 + '%');
                }
            }

            let mousedown_y;
            let container_rect;
            let container_y;
            let container_y_bottom;

            function mousemoveThumb(move_event) {
                if(move_event.pageY <= container_y) {parent.scrollTop = 0;}
                else if(move_event.pageY >= container_y_bottom) {parent.scrollTop = target.scrollHeight - container_rect.height;}
                else {parent.scrollTop = ( move_event.pageY - container_y ) / container_rect.height * ( target.scrollHeight - container_rect.height );}
                parent.onscroll();
            }

            function mousedownThumb(down_event) {

                down_event.preventDefault();
                down_event.stopPropagation();

                mousedown_y = down_event.pageY;
                container_rect = parent.getClientRects()[0];
                container_y = container_rect.y;
                container_y_bottom = container_y + target.scrollHeight;

                thumb.classList.add('active');

                window.onmouseup = mouseupThumb;
                window.onmousemove = mousemoveThumb;
            }

            function mouseupThumb() {
                thumb.classList.remove('active');

                window.onmouseup = null;
                window.onmousemove = null;
            }
        }
    });
    resizeObserver.observe(document.querySelector('.rooms_list'));
    resizeObserver.observe(document.querySelector('.messages_list'));

    let parentResizeObserver = new ResizeObserver((entries) => {
        for (const entry of entries) {
            entry.target.onscroll();
        }
    });
    parentResizeObserver.observe(document.querySelector('.rooms_list_wrap'));
    parentResizeObserver.observe(document.querySelector('.messages_list_wrap'));
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