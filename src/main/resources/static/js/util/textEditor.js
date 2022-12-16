//const event = new CustomEvent('editorSend',{key: value});
class TextEditorHTML extends HTMLElement{

    textarea = undefined;
    attachment = [];

    constructor() {
        super();
        let _this = this;
        this.attachShadow({mode: "open"});

        const style = document.createElement('link');
        style.setAttribute('rel', 'stylesheet');
        style.setAttribute('href', '/css/textEditor.css');

        const tool_bar = document.createElement("div");
        tool_bar.className = "tool_bar";

        const buttons = {};
        buttons.bold = document.createElement("button");
        buttons.italic = document.createElement("button");
        buttons.underline = document.createElement("button");
        buttons.strikeThrough = document.createElement("button");
        buttons.insertOrderedList = document.createElement("button");
        buttons.insertUnorderedList = document.createElement("button");
        buttons.justifyFull = document.createElement("button");
        buttons.justifyLeft = document.createElement("button");
        buttons.justifyCenter = document.createElement("button");
        buttons.justifyRight = document.createElement("button");


        for(let button_name in buttons){
            let button = buttons[button_name];
            button.setAttribute("data-style", button_name);
            button.addEventListener('click', () => setStyle(button.getAttribute("data-style")));
            tool_bar.append(button);
        }

        let input_image = document.createElement("input");
        input_image.setAttribute("type","file");

        let button_image = document.createElement("button");
        button_image.setAttribute("data-style", "image");
        tool_bar.append(button_image);

        button_image.addEventListener('click', () => input_image.click());

        input_image.addEventListener('change', e => {
            const files = e.target.files;
            if (!!files) {
                insertImageData(files[0]);
            }
            e.target.value = '';
        });

        const textarea = document.createElement("div");
        textarea.className = "textarea";
        textarea.contentEditable = true;
        textarea.tabIndex = 0;

        ["mousedown","keydown"].forEach(event => textarea.addEventListener(event, () => checkStyle()));
        textarea.addEventListener("input", e => _this.value = e.target.innerHTML);
        textarea.addEventListener("paste", e => {
            e.preventDefault();
            document.execCommand("insertText", false, (e.originalEvent || e).clipboardData.getData('text/plain'));
        });
        textarea.addEventListener("drop", e => {
            e.preventDefault();
            textarea.classList.remove("dragover");
            if(e.dataTransfer.files.length > 0){
                insertImageData(e.dataTransfer.files[0]);
            }
        });
        textarea.addEventListener("dragover", e => {
            e.preventDefault();
            e.dataTransfer.dropEffect = "move";
            textarea.classList.add("dragover");
        });
        textarea.addEventListener("dragleave", e => {
            e.preventDefault();
            textarea.classList.remove("dragover");
        });

        this.textarea = textarea;

        let button_verticalSize = document.createElement("button");
        button_verticalSize.classList.add("vertical_size");
        let Offset = 0;
        button_verticalSize.addEventListener("mousedown", e => {
            Offset = _this.offsetHeight + _this.getBoundingClientRect().top - e.pageY;
        });
        window.addEventListener("mousemove", e => {
            if($(button_verticalSize).is(":active")){
                _this.style.height = `${Offset + e.pageY - _this.getBoundingClientRect().top}px`;
            }
        });

        this.shadowRoot.append(style);
        this.shadowRoot.append(tool_bar);
        this.shadowRoot.append(textarea);
        this.shadowRoot.append(button_verticalSize);

        this.addEventListener( 'editor_send', e => {
            _this.textarea.innerHTML = _this.value = e.detail;
            _this.textarea.focus();
            let el = $(_this.textarea).get(0);
            el.focus();
            if (typeof window.getSelection != "undefined"
                && typeof document.createRange != "undefined") {
                let range = document.createRange();
                range.selectNodeContents(el);
                range.collapse(false);
                let sel = window.getSelection();
                sel.removeAllRanges();
                sel.addRange(range);
            } else if (typeof document.body.createTextRange != "undefined") {
                let textRange = document.body.createTextRange();
                textRange.moveToElementText(el);
                textRange.collapse(false);
                textRange.select();
            }
        });


        function checkStyle() {
            for(let command in buttons){
                if (isStyle(command)) {
                    buttons[command].classList.add('on');
                } else {
                    buttons[command].classList.remove('on');
                }
            }
        }

        function isStyle(style) {
            return document.queryCommandState(style);
        }

        function setStyle(style) {
            document.execCommand(style);
            checkStyle();
            textarea.focus();
        }

        function insertImageData(file) {

            //파일 타입 검사
            if(file.type.indexOf("image") < 0) return toast("이미지만 선택해서 업로드 해주세요.", TOAST_SHORT);

            //파일 사이즈 검사
            if(file.size > 10485760) return toast("10MB 이하 사이즈만 업로드 해주세요", TOAST_SHORT);

            const reader = new FileReader();
            reader.addEventListener('load', function (e) {
                textarea.focus();
                document.execCommand('insertImage', false, `${reader.result}`);
                _this.attachment.push(file);
            });
            reader.readAsDataURL(file);
        }

    }

    static get observedAttributes() {
        return ['placeholder','value'];
    }

    attributeChangedCallback(name, oldValue, newValue) {
        switch (name){
            case 'placeholder':
                this.textarea.setAttribute(name, newValue);
                break;
            case 'value':
                this.textarea.innerHTML = newValue;
                break;
        }
    }

    createdCallback() {
        this.tabIndex = 0;
    }
}
customElements.define('text-editor',TextEditorHTML);