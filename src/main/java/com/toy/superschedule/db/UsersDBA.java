package com.toy.superschedule.db;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.springframework.stereotype.Component;

import javax.annotation.PostConstruct;
import java.util.HashMap;

@Component
public class UsersDBA extends BaseDBA {
    @PostConstruct
    public void init(){
        FILE_NAME = "user";
        COLUMN = new String[]{"id", "name", "nickname", "pw", "token", "type", "created", "deleted"};
        COLUMN_TYPE = new String[]{"int", "string", "string", "string", "string", "int", "date", "date"};
        initFolder();
        initFile();
        JSONObject json = new JSONObject();
        Object[][] where = new Object[][]{
                {"id", '=', 2},
        };
        json.put("where",where);
        delete(json);
    }
}
