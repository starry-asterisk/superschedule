/**
 * 모달창 생성 기능
 * @param setting set this to false if you want to close modal window
 * @returns void
 */
function modal(setting = {}){
    let wrap = $('.modal_wrap');
    let modal_window = wrap.find('.modal_window');
    wrap.removeClass('on');
    wrap.removeClass('cancel-not');
    modal_window.find(':not(.modal_window > button)').remove();
    if(setting === false){
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
        modal_window.append(wrap);
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
                if(el.type === 'file'){
                    let label = document.createElement('label');
                    label.appendChild(tag[0]);
                    tag.attr('accept','image/*');
                    tag.on('change', e => {
                        if(e.target.files.length < 1){
                            return;
                        }

                        let file = e.target.files[0];
                        //파일 타입 검사
                        if(file.type.indexOf("image") < 0) return toast("이미지만 선택해서 업로드 해주세요.", TOAST_SHORT);

                        //파일 사이즈 검사
                        if(file.size > 10485760) return toast("10MB 이하 사이즈만 업로드 해주세요", TOAST_SHORT);

                        const reader = new FileReader();
                        reader.addEventListener('load', function (e) {
                            let img = document.createElement('img');
                            img.src = reader.result;
                            $(label).find('img').each((i, e) => e.remove());
                            label.classList.add('selected');
                            label.appendChild(img);
                        });
                        reader.readAsDataURL(file);
                    });
                    tag = $(label);
                }
                break;
            case 'label':
                tag = $(document.createElement('label'));
                tag.attr('for',el.for);
                break;
            case 'margin':
                tag = $(document.createElement('div'));
                tag.css('height', el.value + 'px');
                break;
            case 'link':
                tag = $(document.createElement('a'));
                tag.text(el.text);
                tag.attr('href', 'javascript:void(0);');
                tag.on('click',()=>{modal(el.template());});
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
                            modal_window.find('input, textarea').each((idx, el) => {
                                switch (el.getAttribute('type')){
                                    case 'file':
                                        return_data[el.getAttribute('name')] = el.files;
                                        break;
                                    default:
                                        return_data[el.getAttribute('name')] = el.value;
                                        break;
                                }
                            });
                            el.callback(return_data);
                        });
                        break;
                }
                break;
        }
        if(el.class){
            tag.attr('class', el.class);
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
 * 페이지 로드시, 시간
 */
let loaded_current = new Date();

/**
 * 유튜브첨 ~시간 전 같은 문구로 시간 출력
 * @param {Date} date
 * @returns {string}
 */
function getDateStr(date){
    //초 단위
    let str = '';
    let unit_value = 60;//1분 이상
    let date_diff = Math.floor((loaded_current.getTime() - date.getTime()) / 1000);
    if(date_diff >= unit_value){
        unit_value = 3600;//1시간 이상
        if(date_diff >= unit_value){
            unit_value = 86400;//1일 이상
            if(date_diff >= unit_value){
                unit_value = 2678400;//1달 이상
                if(date_diff >= unit_value){
                    let date_computed_year = loaded_current.getFullYear() - date.getFullYear();
                    if(date_computed_year > 0){
                        str += `${date_computed_year}년 `;
                    }
                    let date_computed_month = loaded_current.getMonth() - date.getMonth();
                    if(date_computed_month > 0){
                        str += `${date_computed_month}개월 `;
                    }
                } else {
                    str += `${Math.floor(date_diff * 31 / unit_value)}일 `;
                }
            } else {
                str += `${Math.floor(date_diff * 24 / unit_value)}시간 `;
            }
        } else {
            str += `${Math.floor(date_diff * 60 / unit_value)}분 `;
        }
    } else {
        str += `${Math.floor(date_diff * 60 / unit_value)}초 `;
    }
    str += `전`;

    return str;
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
$(document).on('click','selectmenu option', e => {e.target.parentElement.blur();$(e.target.parentElement).children().attr('selected',false);e.target.setAttribute('selected', true);});


