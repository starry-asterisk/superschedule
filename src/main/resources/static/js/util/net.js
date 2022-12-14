/**
 * POST, PUT, DELETE 용 ajax
 * @param url 주소
 * @param data 변수
 * @param method
 * @param header
 * @returns {Promise<any>}
 */
async function ajax(url = '', data = {}, method= "POST", header = {}) {
    // 옵션 기본 값은 *로 강조
    const response = await fetch(url, {
        method: method, // *GET, POST, PUT, DELETE 등
        mode: 'cors', // this cannot be 'no-cors'
        headers: {
            ...header,
            'Accept': 'application/json',
            'Content-Type': 'application/json',
        },
         body: JSON.stringify(data), // body 의 데이터 유형은 반드시 "Content-Type" 헤더와 일치해야 함
    });
    return response.json(); // JSON 응답을 네이티브 JavaScript 객체로 파싱
}

/**
 * GET 요청 전용 ajax
 * @param url 주소
 * @param data 변수
 * @param header
 * @returns {Promise<any>}
 */
async function ajaxGet(url = '', data = {}, header = {}) {
    let pathStr = '';
    for(let key in data){
        pathStr += `&${key}=${data[key]}`;
    }
    pathStr = pathStr.replace('&','?');
    const response = await fetch(url + pathStr, {
        method: "GET", // *GET, POST, PUT, DELETE 등
        mode: 'cors', // this cannot be 'no-cors'
        headers: {
            ...header,
            'Accept': 'application/json',
            'Content-Type': 'application/json',
        }
    });
    return response.json(); // JSON 응답을 네이티브 JavaScript 객체로 파싱
}

/**
 * GET/HEAD 요청 전용 ajax
 * @param url 주소
 * @param data 변수
 * @param header
 * @returns {Promise<any>}
 */
async function ajaxHead(url = '', data = {}, header = {}) {
    let pathStr = '';
    for(let key in data){
        pathStr += `&${key}=${data[key]}`;
    }
    pathStr = pathStr.replace('&','?');
    return fetch(url + pathStr, {
        method: "HEAD", // *GET, POST, PUT, DELETE 등
        mode: 'cors', // this cannot be 'no-cors'
        headers: {
            ...header,
            'Accept': 'application/json',
            'Content-Type': 'application/json',
        }
    }); // JSON 응답을 네이티브 JavaScript 객체로 파싱
}

/**
 * File Upload 용 ajax
 * @param url 주소
 * @param data 변수
 * @param method
 * @returns {Promise<any>}
 */
async function ajaxFile(url = '', data = {}, method= "POST") {
    let form = new FormData();
    for(let key in data){
        if(key.indexOf('file') > -1){
            for(let index in data[key]){
                form.append(key, data[key][index]);
            }
        }else{
            form.append(key, data[key]);
        }
    }
    // 옵션 기본 값은 *로 강조
    const response = await fetch(url, {
        method: method, // *GET, POST, PUT, DELETE 등
        mode: 'cors', // this cannot be 'no-cors'
        headers: {},
        body: form, // body 의 데이터 유형은 반드시 "Content-Type" 헤더와 일치해야 함
    });
    return response.json(); // JSON 응답을 네이티브 JavaScript 객체로 파싱
}