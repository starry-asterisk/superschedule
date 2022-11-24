package com.toy.superschedule.db;

import org.springframework.stereotype.Component;

import javax.annotation.PostConstruct;

@Component
public class ReplyDBA extends BaseDBA {
    @PostConstruct
    public void init(){
        FILE_NAME = "reply";
        COLUMN = new String[]{"id", "board_id", "contents", "author", "author_nickname", "created", "updated"};
        COLUMN_TYPE = new String[]{"int", "int", "string", "string", "string", "date", "date"};
        initFolder();
        initFile();
    }
}
