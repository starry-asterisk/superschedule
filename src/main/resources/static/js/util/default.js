function modal(setting = {}){
    let wrap = $('.modal_wrap');
    let modal = wrap.find('.modal_window');
    if(setting === false){
        wrap.removeClass('on');
        wrap.removeClass('cancel-not');
        modal.find(':not(.modal_window > button)').remove();
        return 0;
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
function toast(msg, time){
    alert(msg);
}
function getDbStr(str, dir = true){
    if(dir){
        return str.replaceAll('\n','$n').replaceAll('\r','$r').replaceAll(',','$u002c');
    }else{
        return str.replaceAll('$n','\n').replaceAll('$r','\r').replaceAll('$u002c',',');
    }
}
const TOAST_SHORT = 1500;
const TOAST_LONG = 2500;
const template = {};
$(document).on('click','.modal_close', () => {modal(false);});

