package com.toy.superschedule.db;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.PropertySource;

import java.io.*;
import java.sql.Timestamp;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import static com.toy.superschedule.Util.util.*;


@PropertySource(value = "application.yml")
public class BaseDBA {

    @Value("${db.path}")
    public String PATH;
    public String FILE_NAME;
    public String EXTENSION = ".txt";
    public String NEW_LINE = "\n";
    public String DELIMITER = ",";
    public String[] DEFAULT_ORDER = {};
    public Object[][] DEFAULT_WHERE = {};
    public int DEFAULT_LIMIT = 0;
    public String[] COLUMN;
    public String[] COLUMN_TYPE;
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
            File file = new File(PATH + FILE_NAME + EXTENSION);

            if (file.exists()) {
                file.createNewFile();

                BufferedReader reader = getReader(file);

                table = setLine(reader);
                table_cnt = table.size();

                reader.close();
            } else {
                file.createNewFile();

                BufferedWriter writer = getWriter(file);

                writer.write(getLine(COLUMN));

                writer.close();
            }



        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    public String getLine(String[] column){
        return String.join(DELIMITER, column) + "\r\n";
    }

    public JSONArray setLine(BufferedReader r) throws IOException {
        return setLine(r, new JSONArray());
    }

    public JSONArray setLine(BufferedReader r, JSONArray data) throws IOException {
        String line = r.readLine();
        if (line != null) {
            String[] values = line.split(DELIMITER);
            JSONObject json = new JSONObject();
            for(int i=0;i < COLUMN.length;i++){
                if(empty(values[i])){
                    json.put(COLUMN[i] , null);
                    continue;
                }
                Object classified_value;
                switch (COLUMN_TYPE[i]) {
                    case "int":
                        classified_value = Integer.parseInt(values[i]);
                        break;
                    case "boolean":
                        classified_value = Boolean.parseBoolean(values[i]);
                        break;
                    case "date":
                        classified_value = Long.parseLong(values[i]);
                        break;
                    case "string":
                    default:
                        classified_value = values[i];
                        break;
                }
                json.put(COLUMN[i], classified_value);
            }
            data.add(json);
            return setLine(r, data);
        } else {
            return data;
        }
    }

    public BufferedWriter getWriter(File file) throws IOException {
        return new BufferedWriter(new FileWriter(file));
    }

    public BufferedReader getReader(File file) throws IOException {
        return new BufferedReader(new FileReader(file));
    }

    public JSONArray find() {
        return find(new JSONObject());
    }
    public JSONArray find(JSONObject condition) {
        JSONArray result = new JSONArray();
        int limit = (int) condition.getOrDefault("limit", DEFAULT_LIMIT);
        Object[][] where = (Object[][]) condition.getOrDefault("where", DEFAULT_WHERE);
        String[] orderBy = (String[]) condition.getOrDefault("orderBy", DEFAULT_ORDER);
        int idx = 0;
        Iterator i = table.iterator();
        while(i.hasNext() && (limit == 0 || limit > idx)){
            JSONObject json = (JSONObject) i.next();
            Boolean isPassed = true;
            for(int j = 0;j < where.length;j++){
                isPassed = evalBoolean((Character) where[j][1], json.get(where[j][0]), where[j][2]);
                if(!isPassed){
                    break;
                }
            }
            if(isPassed){
                result.add(json);
                idx++;
            }
        }
        return result;
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
