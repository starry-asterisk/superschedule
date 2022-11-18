function login(isAuto = false, token){
    let data = {};
    if(isAuto === true){
        data.token = token;
    }else{
        data = isAuto;
        if(!data.id || !data.pw){
            return toast("로그인 정보를 입력해 주세요!", TOAST_SHORT);
        }
    }
    $('.loading').show();
    postData('/login', data).then((result) => {
        $('.loading').hide();
        switch (result.status){
            case 404:
                localStorage.removeItem('login_token');
                if(isAuto !== true){
                    toast("로그인 실패!", TOAST_SHORT);
                }
                break;
            case 200:
                if(isAuto !== true){
                    //localStorage.setItem('login_token', result.token);
                    modal(false);
                    location.reload();
                }
        }
    });
}

function logout(){
    $('.loading').show();
    postData('/logout', {}).then((result) => {
        $('.loading').hide();
        switch (result.status){
            case 200:
                localStorage.removeItem('login_token');
                location.reload();
            default:
                console.error("logout failed...");
                console.log(result);
                break;
        }
    });
}

template.login = {
        cancelable: true,
        period: 0,
        lines: [
            {role: 'title', text: 'Login'},
            {role: 'content', text: '로그인 정보를 입력해 주세요.'},
            {role: 'margin', value: 15},
            {role: 'input', type: 'text', name: 'id', value: '', placeholder: 'ID'},
            {role: 'input', type: 'password', name: 'pw', value: '', placeholder: 'PASSWORD'},
            {role: 'margin', value: 15},
            [{role: 'button', type: 'apply', text: 'apply', callback: login}, {role: 'button', type: 'cancel', text: 'cancel'}]
        ],
    };

/*
* 자동 로그인 예약 실행
* */
if(loginData){
    $(document).ready(e => {
        $('.header_sub').text(`hello ${loginData.nickname} | sign out`);
    });
}else{
    let login_token = localStorage.getItem('login_token');
    if(login_token){
        login(true, login_token);
    }
}

