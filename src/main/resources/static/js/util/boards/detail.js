/**
 * 댓글 목록을 불러와주는 기능
 */
function list(){
    $('.loading').show();
    ajaxGet(`/boards/${board_id}/replies`).then((data) => {
        data.result.forEach(
            li => {
                renderReply({
                    id: li.id,
                    contents: li.contents,
                    author: li.author_nickname,
                    datetime: new Date(li.created)
                });
            }
        );
        $('.loading').hide();
    });
}

function renderReply (data =
        {contents: '[sample contents]', author: '[sample author]', datetime: new Date()}
) {
    let reply = document.createElement('div');
    let profile = document.createElement('img');
    profile.classList.add('reply_profile');
    profile.src = `/users/img/${loginData.id}`;
    profile.alt = `${loginData.nickname[0]}`;
    let author = document.createElement('span');
    author.classList.add('reply_author');
    author.innerText= data.author;
    let datetime = document.createElement('span');
    datetime.classList.add('reply_datetime');
    datetime.innerText= getDateStr(data.datetime);
    let contents = document.createElement('div');
    contents.classList.add('reply_contents');
    contents.innerHTML = data.contents;
    reply.appendChild(profile);
    reply.appendChild(author);
    reply.appendChild(datetime);
    reply.appendChild(contents);
    document.querySelector('.reply_list').appendChild(reply);
}


/**
 * 댓글 작성 기능
 */
function put_reply(){
    let simple = document.querySelector('.reply_simple');
    let detailed = document.querySelector('.reply_detailed');
    let contents = simple.classList.contains('on')?simple.value:detailed.value;
    if(contents != null && contents.length > 0){

        $('.loading').show();
        ajax(`/boards/${board_id}/replies`, {
            contents: contents,
            datetime: loaded_current
        }, 'PUT').then((result) => {
            $('.loading').hide();
            switch (result.status){
                case 200:
                    renderReply({
                        id: result.id,
                        contents: contents,
                        author: loginData.nickname,
                        datetime: loaded_current
                    });
                    break;
                default:
                    toast('댓글 등록에 실패 했습니다.');
                    setTimeout(() => location.reload(), TOAST_SHORT);
                    break;
            }
        });

        simple.value = '';
        detailed.value = '';
        detailed.setAttribute('value','');
    }else{
        toast('먼저 내용을 작성해 주세요.')
    }
}