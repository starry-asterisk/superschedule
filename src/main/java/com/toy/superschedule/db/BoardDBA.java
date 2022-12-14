package com.toy.superschedule.db;

import org.springframework.stereotype.Component;
import javax.annotation.PostConstruct;

@Component
public class BoardDBA extends BaseDBA {
    @PostConstruct
    public void init(){
        FILE_NAME = "board";
        COLUMN = new String[]{"id", "title", "contents", "author", "author_nickname", "cleared", "danger_level", "due_date", "created", "updated"};
        COLUMN_TYPE = new String[]{"int", "string", "string", "string", "string", "boolean", "int", "date", "date", "date"};
        initFolder();
        initFile();
    }
}
