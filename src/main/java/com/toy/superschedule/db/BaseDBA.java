package com.toy.superschedule.db;

import org.springframework.beans.factory.annotation.Value;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;

abstract class BaseDBA {

    @Value("${db.path}")
    private String PATH;
    String FILE_NAME;

    public BaseDBA(){
        init();
    }

    public void init(){
        try {

            File dir = new File(PATH);

            if(!dir.exists()){
                dir.mkdir();
            }

            // 1. 파일 객체 생성
            File file = new File(PATH + FILE_NAME);

            // 2. 파일 존재여부 체크 및 생성
            if (!file.exists()) {
                file.createNewFile();
            }

            // 3. Buffer를 사용해서 File에 write할 수 있는 BufferedWriter 생성
            FileWriter fw = new FileWriter(file);
            BufferedWriter writer = new BufferedWriter(fw);

            // 4. 파일에 쓰기
            writer.write("안녕하세요");

            // 5. BufferedWriter close
            writer.close();

        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
