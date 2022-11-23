/**
 * 모달창 생성 기능
 * @param setting set this to false if you want to close modal window
 * @returns void
 */
function modal(setting = {}){
    let wrap = $('.modal_wrap');
    let modal = wrap.find('.modal_window');
    if(setting === false){
        wrap.removeClass('on');
        wrap.removeClass('cancel-not');
        modal.find(':not(.modal_window > button)').remove();
        return;
    }
    if(setting.cancelable === false){
        wrap.addClass('cancel-not');
    }
    setting.lines.forEach(el => {
        let wrap = $(document.createElement('div'));
        if(typeof el.find==='function'){
            el.forEach(el_child => {
                wrap.append(getTag(el_child));
            });
        }else{
            wrap.append(getTag(el));
        }
        modal.append(wrap);
    });
    wrap.addClass('on');
    if(setting.period > 0){
        setTimeout(() => {modal(false);}, setting.period);
    }

    /**
     * get element for modal
     * @param el settings Object
     * @returns {HTMLElement} tag
     */
    function getTag(el) {
        let tag;
        switch(el.role){
            case 'title':
                tag = $(document.createElement('span'));
                tag.addClass('modal_title');
                tag.text(el.text);
                break;
            case 'content':
                tag = $(document.createElement('span'));
                tag.text(el.text);
                break;
            case 'input':
                tag = $(document.createElement('input'));
                tag.val(el.value);
                tag.attr('placeholder',el.placeholder);
                tag.attr('name',el.name);
                tag.attr('type',el.type);
                tag.prop('value',el.value);
                break;
            case 'label':
                tag = $(document.createElement('label'));
                tag.attr('for',el.for);
                break;
            case 'margin':
                tag = $(document.createElement('div'));
                tag.css('height', el.value + 'px');
                break;
            case 'button':
                tag = $(document.createElement('button'));
                tag.text(el.text);
                switch (el.type){
                    case 'cancel':
                        tag.addClass('modal_close');
                        tag.addClass('invert');
                        break;
                    case 'apply':
                        tag.on('click', () => {
                            let return_data = {};
                            modal.find('input, textarea').each((idx, el) => {
                                return_data[el.getAttribute('name')] = el.value;
                            });
                            el.callback(return_data);
                        });
                        break;
                }
                break;
        }
        return tag;
    }
}

/**
 * 일정시간동안 간단한 메시지를 띄워줌
 * @param msg text want to show
 * @param time set time you want to show by millisecond
 */
function toast(msg, time = TOAST_SHORT){
    let p = document.createElement('p');
    p.innerHTML = msg;
    p.classList.add('toast');
    document.body.appendChild(p);
    setTimeout(() => {
        $(p).css('animation-name', 'fadeOut');
        setTimeout(() => {
            $(p).remove();
        },200);
    },time);
}

/**
 * DB insert용으로 사용 불가한 특수문자를 escape처리 시켜줌
 * @param str text
 * @param dir false면 문장을 원상복구 시켜준다
 * @returns {string}
 */
function getDbStr(str, dir = true){
    if(dir){
        return str.replaceAll('\n','$n').replaceAll('\r','$r').replaceAll(',','$u002c');
    }else{
        return str.replaceAll('$n','\n').replaceAll('$r','\r').replaceAll('$u002c',',');
    }
}

/**
 * 토스트 메시징시 사용할 시간 변수
 */
const TOAST_SHORT = 2000;
const TOAST_LONG = 3200;

/**
 * 템플릿 저장용 변수
 */
const template = {};

/**
 * 모달창 종료 버튼 클릭시 자동 종료 listener
 */
$(document).on('click','.modal_close', () => {modal(false);});

