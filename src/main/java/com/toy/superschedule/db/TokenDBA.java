package com.toy.superschedule.db;

import org.springframework.stereotype.Component;

import javax.annotation.PostConstruct;

@Component
public class TokenDBA extends BaseDBA {
    @PostConstruct
    public void init(){
        FILE_NAME = "token";
        COLUMN = new String[]{"id", "owner", "type", "user_secret", "access_token", "access_expired_date", "refresh_token", "refresh_expired_date", "created", "updated"};
        COLUMN_TYPE = new String[]{"int", "string", "string", "string", "string", "date", "string", "date", "date", "date"};
        initFolder();
        initFile();
    }
}
