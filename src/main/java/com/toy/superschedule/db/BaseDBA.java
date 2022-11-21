package com.toy.superschedule.db;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.PropertySource;
import java.io.*;
import java.util.*;

import static com.toy.superschedule.Util.util.*;


@PropertySource(value = "application.yml")
public class BaseDBA {

    @Value("${db.path}")
    public String PATH;
    public String FILE_NAME;
    public String EXTENSION = ".txt";
    public String NEW_LINE_DELIMITER = "\r\n";
    public String DELIMITER = ",";
    public String[] DEFAULT_ORDER = {"id"};
    public Object[][] DEFAULT_WHERE = {};
    public int DEFAULT_LIMIT = 0;
    public String[] COLUMN;
    public String[] COLUMN_TYPE;
    public JSONArray table;
    public int table_cnt = 0;
    public int table_increment = 0;

    public void initFolder(){
        try {
            File dir = new File(PATH);

            if(!dir.exists()){
                if(!dir.mkdirs()){
                    throw new Exception();
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void initFile() {
        try {
            File file = new File(PATH + FILE_NAME + EXTENSION);

            if (file.exists()) {

                BufferedReader reader = getReader(file);

                table = setLine(reader);
                table_cnt = table.size();

                reader.close();
            } else if(!file.createNewFile()){
                throw new IOException();
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    public String getLine(JSONObject data){
        Object v;
        StringBuilder insert_string = new StringBuilder();
        for(int i=0;i < COLUMN.length - 1;i++){
            v = data.get(COLUMN[i]);
            if(v != null){
                insert_string.append(v);
            }else{
                data.put(COLUMN[i], null);
            }
            insert_string.append(DELIMITER);
        }
        v = data.get(COLUMN[COLUMN.length - 1]);
        if(v != null){
            insert_string.append(v);
        }else{
            data.put(COLUMN[COLUMN.length - 1], null);
        }
        insert_string.append(NEW_LINE_DELIMITER);
        return insert_string.toString();
    }

    public JSONArray setLine(BufferedReader r) throws IOException {
        return setLine(r, new JSONArray());
    }

    public JSONArray setLine(BufferedReader r, JSONArray data) throws IOException {
        String line = r.readLine();
        if (line != null) {
            String[] values = line.split(DELIMITER, -1);
            int id = Integer.parseInt(values[0]);
            if(id > table_increment){
                table_increment = id;
            }
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
            table_increment++;
            return data;
        }
    }

    public BufferedWriter getWriter(File file) throws IOException {
        return new BufferedWriter(new FileWriter(file, true));
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
        if(orderBy.length > 0){
            table.sort(Comparator.comparing((JSONObject a) -> a.get(orderBy[0]).toString()));
        }

        ListIterator i = table.listIterator();
        while(i.hasNext() && (limit == 0 || limit > idx)){
            JSONObject json = (JSONObject) i.next();
            boolean isPassed = true;
            for (Object[] evalCondition : where) {
                isPassed = evalBoolean((Character) evalCondition[1], json.get(evalCondition[0]), evalCondition[2]);
                if (!isPassed) {
                    break;
                }
            }
            if(isPassed){
                json.put("row_num", i.previousIndex());
                result.add(json);
                idx++;
            }
        }
        return result;
    }

    public boolean insert(BufferedWriter writer, JSONObject data) throws IOException {
        data.put("id", table_increment);
        writer.write(getLine(data));
        table_increment++;
        table_cnt++;
        table.add(data);
        return true;
    }

    public boolean insertWithId(BufferedWriter writer, JSONObject data) throws IOException {
        writer.write(getLine(data));
        table.add(data);
        return true;
    }

    public boolean insertOne(JSONObject data) {
        try {
            File file = new File(PATH + FILE_NAME + EXTENSION);
            if (file.exists()) {
                BufferedWriter writer = getWriter(file);
                insert(writer, data);
                writer.close();
            }
            return true;
        } catch(Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public int insertAll(List<JSONObject> data) {
        return insertAll(data, false);
    }
    public int insertAll(List<JSONObject> data, boolean withId) {
        Iterator<JSONObject> i = data.iterator();
        int total_cnt = 0;
        try {
            File file = new File(PATH + FILE_NAME + EXTENSION);
            if (file.exists()) {
                BufferedWriter writer = getWriter(file);
                while(i.hasNext()){
                    if(withId?insertWithId(writer, i.next()):insert(writer, i.next())){
                        total_cnt++;
                    }
                }
                writer.close();
            }

        } catch(Exception e) {
            e.printStackTrace();
        }
        return total_cnt;
    }

    public int delete(JSONObject condition) {
        return delete(condition, 0);
    }

    public int delete(JSONObject condition, int limit) {
        condition.put("limit", limit);
        JSONArray delete_arr = find(condition);
        int cnt = delete(delete_arr);
        table_cnt -= cnt;
        return cnt;
    }

    public int delete(JSONArray delete_arr) {
        int cnt = delete_arr.size();
        Iterator<JSONObject> i = delete_arr.iterator();
        while(i.hasNext()){
            table.remove(Integer.parseInt(i.next().get("row_num").toString()));
        }
        i = table.iterator();
        File file = new File(PATH + FILE_NAME + EXTENSION);
        try {
            PrintWriter out = new PrintWriter(new FileWriter(file));
            while(i.hasNext()){
                out.print(getLine(i.next()));
            }
            out.flush();
            out.close();
        } catch(Exception e){
            e.printStackTrace();
        }
        return cnt;
    }

    public int update(JSONObject condition, JSONObject data) {
        return update(condition, data, 0);
    }

    public int update(JSONObject condition, JSONObject data, int limit) {
        condition.put("limit", limit);
        JSONArray update_arr = find(condition);
        if(delete(update_arr) > 0){
            for(int i = update_arr.size() ; i > 0 ; i--){
                JSONObject json = (JSONObject) update_arr.get(i - 1);
                json.putAll(data);
            }
            insertAll(update_arr, true);
        }
        return 0;
    }
}
