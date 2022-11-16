package com.toy.superschedule.db;

import lombok.extern.slf4j.Slf4j;
import org.json.simple.JSONArray;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.PropertySource;
import org.springframework.stereotype.Component;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.util.Iterator;
import java.util.List;
import java.util.Map;


@PropertySource(value = "application.yml")
public class BaseDBA {

    @Value("${db.path}")
    public String PATH;
    public String FILE_NAME;
    public String EXTENSION = ".txt";
    public String NEW_LINE = "\n";
    public String DELIMITER = ",";
    public String[] COLUMN;
    public JSONArray table;
    public int table_cnt = 0;

    public void initFolder(){
        try {
            File dir = new File(PATH);

            if(!dir.exists()){
                dir.mkdirs();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void initFile() {
        try {
            // 1. 파일 객체 생성
            File file = new File(PATH + FILE_NAME + EXTENSION);

            // 2. 파일 존재여부 체크 및 생성
            if (!file.exists()) {
                file.createNewFile();
            }

            // 3. Buffer를 사용해서 File에 write할 수 있는 BufferedWriter 생성
            FileWriter fw = new FileWriter(file);
            BufferedWriter writer = new BufferedWriter(fw);

            // 4. 파일에 쓰기
            writer.write(getHeader(COLUMN));

            // 5. BufferedWriter close
            writer.close();

        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    public String getHeader(String[] column){
        int idx = 0;
        String r = "  |  ";
        while (column.length > idx){
            r += column[idx] + "  |  ";
            idx++;
        }
        return r;
    }

    public boolean insert(Map<String, Object> data) {
        return false;
    }

    public int insert(List<Map<String, Object>> data) {
        Iterator<Map<String, Object>> i = data.iterator();
        int total_cnt = 0;
        while(i.hasNext()){
            if(insert(i.next())){
                total_cnt++;
            }
        }
        return total_cnt;
    }

    public int delete(Map<String, Object> condition) {
        return delete(condition, 0);
    }

    public int delete(Map<String, Object> condition, int limit) {
        return 0;
    }

    public int update(Map<String, Object> condition, Map<String, Object> data) {
        return update(condition, data, 0);
    }

    public int update(Map<String, Object> condition, Map<String, Object> data, int limit) {
        return 0;
    }
}
