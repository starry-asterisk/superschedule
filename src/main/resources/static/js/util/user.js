/**
 * 로그인 기능
 * @param isAuto 자동 로그인 체크
 * @param token 자동 로그인용 토큰
 */
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
    ajax('/users/login', data, 'PUT').then((result) => {
        $('.loading').hide();
        switch (result.status){
            case 404:
                localStorage.removeItem('login_token');
                if(isAuto !== true){
                    toast("아이디 또는 패스워드가 일치하지 않습니다.", TOAST_SHORT);
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

/**
 * 로그아웃 기능, 로그아웃 성공 시 페이지 새로고침을 한다
 */
function logout(){
    $('.loading').show();
    ajax('/users/logout', {}, 'PUT').then((result) => {
        $('.loading').hide();
        switch (result.status){
            case 200:
                localStorage.removeItem('login_token');
                location.reload();
                break;
            default:
                console.error("logout failed...");
                console.log(result);
                break;
        }
    });
}

/**
 * 회원가입 요청 기능
 * @param data 새로운 회원 정보
 */
function signUp(data){
    console.log(data);
    toast('아직 기능이 완성되지 않았어요!');
}

/*
로그인 modal용 템플릿
 */
template.login = {
        cancelable: true,
        period: 0,
        lines: [
            {role: 'margin', value: 15},
            {role: 'title', text: 'Login'},
            {role: 'content', text: '로그인 정보를 입력해 주세요.'},
            {role: 'margin', value: 15},
            {role: 'input', type: 'text', name: 'id', value: '', placeholder: 'ID', class:'input_st_underline'},
            {role: 'input', type: 'password', name: 'pw', value: '', placeholder: 'PASSWORD', class:'input_st_underline'},
            {role: 'margin', value: 15},
            {role: 'link', text: 'sign up', template: () => template.signUp},
            {role: 'margin', value: 15},
            [{role: 'button', type: 'apply', text: 'apply', callback: login}, {role: 'button', type: 'cancel', text: 'cancel'}],
            {role: 'margin', value: 15},
        ],
    };

/*
회원가입 modal용 템플릿
 */
template.signUp = {
    cancelable: true,
    period: 0,
    lines: [
        {role: 'margin', value: 15},
        {role: 'title', text: 'Sign Up'},
        {role: 'content', text: '회원 정보를 입력해 주세요.'},
        {role: 'margin', value: 15},
        {role: 'input', type: 'text', name: 'nickname', value: '', placeholder: 'NAME', class:'input_st_underline'},
        {role: 'input', type: 'text', name: 'name', value: '', placeholder: 'ID', class:'input_st_underline'},
        {role: 'input', type: 'password', name: 'pw', value: '', placeholder: 'PASSWORD', class:'input_st_underline'},
        {role: 'input', type: 'password', name: 'pw_confirm', value: '', placeholder: 'PASSWORD CONFIRM', class:'input_st_underline'},
        {role: 'margin', value: 15},
        [{role: 'button', type: 'apply', text: 'apply', callback: signUp}, {role: 'button', type: 'cancel', text: 'cancel'}],
        {role: 'margin', value: 15}
    ],
};

/*
* 자동 로그인 예약 실행
* */
if(loginData){
    $(document).ready(() => {
        $('.header_sub').text(`hello ${loginData.nickname} | sign out`);
    });
}else{
    let login_token = localStorage.getItem('login_token');
    if(login_token){
        login(true, login_token);
    }
}

