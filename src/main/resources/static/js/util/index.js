/**
 * 게시글 작성 폼 등장
 */
function go(){
    //login validation
    if(loginData){
        //accept
        $('.go_btn').toggleClass('on');
        $('.input_title').focus();
    }else{
        //denied
        toast('로그인을 진행 해주셔야 진행 가능한 기능입니다',TOAST_LONG);
    }
}

/**
 * 게시글 제목 제출
 */
function apply(){
    $('.apply_btn').toggleClass('on');
    $('.input_title').prop('disabled', true);
}

/**
 * 게시글 제목 + 내용 제출
 */
function upload(){
    $('.input_description').prop('disabled', true);
    $('.upload_btn').prop('disabled',true);
    $('.loading').show();
    ajax('/boards', {
        title: getDbStr($('.input_title').val()),
        level: $('.input_level option[selected=true]').val(),
        description: getDbStr($('.input_description').val())
    },'POST').then((data) => {
        $('.loading').hide();
        if(data.result){
            //reload page if result is success
            location.reload();
        }else{
            toast('게시글 작성에 실패했습니다.',TOAST_LONG);
        }
    });
}

/**
 * 게시글 목록을 불러와주는 기능
 */
function list(param = {}){
    if(param.target != null){
        param = {};
    }
    $('.loading').show();
    ajaxGet('/boards', param).then((data) => {
        let wrap = document.createElement("div");
        let user_name = loginData!=null?loginData.name:null;
        data.result.forEach(
            li => {
                wrap.innerHTML =
                    `<div class="li${li.author==user_name?' my':''}" data-id="${li.id}">`+
                    `<svg>`+
                    `<rect height="100%" width="100%"/>`+
                    `</svg>`+
                    `<div class="level" value="${li.danger_level}"><span class="checkbox"></span></div>`+
                    `<div class="title">${getDbStr(li.title, false)}</div>`+
                    `<div class="author_nickname">${li.author_nickname}</div>`+
                    `<div class="li_detail">`+
                    `<div class="info_bar">`+
                    `<button data-id="${li.id}" class="board_del" icon="&#xF5DD" title="삭제"></button>`+
                    `<button data-id="${li.id}" class="board_edit" icon="&#xF5DB" title="수정"></button>`+
                    `<button data-id="${li.id}" class="board_reply" icon="&#xF51F" title="댓글로 이동"></button>`+
                    `<div class="created">${new Date(li.created).toLocaleString()}</div>`+
                    `</div>`+
                    `<pre class="contents">${getDbStr(li.contents, false)}</pre>`+
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

/**
 * 게시글 작성 form validation
 * @param {String} type
 * @returns {boolean} it's false if form is acceptable
 */
function validate(type = 'default'){
    let v, r = false;
    switch(type){
        case 'default':
        case 'title':
            v = $('.input_title').val();
            r = !v;
            $('.apply_btn').prop('disabled',r);
            if(type === 'title'){break;}
        case 'description':
            v = $('.input_description').val();
            r = !v;
            $('.upload_btn').prop('disabled',r);
            if(type === 'description'){break;}
    }
    return !r;
}

function boardDel(e){
    if(e.id != null){
        $('.loading').show();
        ajax('/boards/' + e.id, {},'DELETE').then((data) => {
            $('.loading').hide();
            if(data.result){
                //reload page if result is success
                location.reload();
            }else{
                toast('게시글 삭제에 실패했습니다.',TOAST_LONG);
            }
        });
    }else{
        modal(template.board_del({value: $(e.target).data('id')}));
    }
}

function boardEdit(e){

}

function boardReply(e){

}

template.board_del = el => {return {
    cancelable: true,
    period: 0,
    lines: [
        {role: 'title', text: '게시글 삭제'},
        [{role: 'content', text: '해당 글을 삭제 할까요?'},{role: 'input', type: 'hidden', name: 'id', value: el.value, placeholder: 'ID'}],
        {role: 'margin', value: 15},
        [{role: 'button', type: 'apply', text: 'apply', callback: boardDel}, {role: 'button', type: 'cancel', text: 'cancel'}]
    ],
}};
$(document).ready(()=>{
   if(location.search.length > 1){
       const param = {};
       location.search.replace("?","").split("&").forEach(el => {
           let key = el.split("=")[0];
           let value = el.split("=")[1];
           param[key] = value;
       });
       list(param);
   }
});