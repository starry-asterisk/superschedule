class TextEditorHTML extends HTMLElement{

    //initial value of editor
    value = '';

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

        button_image.addEventListener('click', function () {
            input_image.click();
        });

        input_image.addEventListener('change', function (e) {
            const files = e.target.files;
            if (!!files) {
                insertImageDate(files[0]);
            }
            e.target.value = '';
        });

        const textarea = document.createElement("div");
        textarea.className = "textarea";
        textarea.setAttribute("contenteditable", true);

        ["mousedown","keydown"].forEach(event => textarea.addEventListener(event, () => checkStyle()));
        textarea.addEventListener("input", e => _this.value = e.target.innerHTML);
        textarea.addEventListener("paste", e => {
            e.preventDefault();
            document.execCommand("insertText", false, (e.originalEvent || e).clipboardData.getData('text/plain'));
        });

        this.shadowRoot.append(style);
        this.shadowRoot.append(tool_bar);
        this.shadowRoot.append(textarea);


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

        function insertImageDate(file) {
            const reader = new FileReader();
            reader.addEventListener('load', function (e) {
                textarea.focus();
                document.execCommand('insertImage', false, `${reader.result}`);
            });
            reader.readAsDataURL(file);
        }
    }
}
customElements.define('text-editor',TextEditorHTML);