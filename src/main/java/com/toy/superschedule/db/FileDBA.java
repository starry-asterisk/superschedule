package com.toy.superschedule.db;

import org.springframework.stereotype.Component;

import javax.annotation.PostConstruct;

@Component
public class FileDBA extends BaseDBA {
    @PostConstruct
    public void FileDBA(){
        FILE_NAME = "file";
        COLUMN = new String[]{"id", "name", "size", "type", "owner", "folder", "key", "created", "updated"};
        COLUMN_TYPE = new String[]{"int", "string", "int", "string", "string", "string", "string", "date", "date"};
        initFolder();
        initFile();
    }
}
