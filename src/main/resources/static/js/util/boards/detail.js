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