package com.toy.superschedule.db;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import javax.annotation.PostConstruct;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;

@Component
public class BoardDBA extends BaseDBA {

    @PostConstruct
    public void init(){
        FILE_NAME = "board";
        COLUMN = new String[]{"id", "title", "contents", "author", "cleared", "danger_level", "due_date", "created", "updated"};
        COLUMN_TYPE = new String[]{"int", "string", "string", "string", "boolean", "int", "date", "date", "date"};
        initFolder();
        initFile();
    }


    @Override
    public void initFile(){
        super.initFile();
    }
}
