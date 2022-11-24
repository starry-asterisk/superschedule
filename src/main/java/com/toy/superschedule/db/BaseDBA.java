package com.toy.superschedule.db;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.PropertySource;
import java.io.*;
import java.util.*;

import static com.toy.superschedule.Util.util.*;

/**
 * 기본 DBA객체 txt파일을 이용해서 DB처럼 작동한다
 */
@PropertySource(value = "application.yml")
public class BaseDBA {

    @Value("${db.path}")
    public String PATH;
    public String FILE_NAME;
    public String EXTENSION = ".txt";
    public String NEW_LINE_DELIMITER = "\r\n";
    public String DELIMITER = ",";
    public String[] DEFAULT_ORDER = {};
    public Object[][] DEFAULT_WHERE = {};
    public int DEFAULT_LIMIT = 0;
    public String[] COLUMN;
    public String[] COLUMN_TYPE;
    public JSONArray table;
    public int table_cnt = 0;
    public int table_increment = 0;
    public int DEFAULT_PAGINATION = 20;

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
        String orderBy = (String) condition.get("orderBy");
        int orderASC = (int) condition.getOrDefault("orderASC", 1);
        int page = (int) condition.getOrDefault("page", 0);

        int idx = 0;
        if(orderBy!=null){
            Comparator<JSONObject> c = Comparator.comparing((JSONObject a) -> a.get(orderBy).toString());
            if(orderASC < 0){
                c = c.reversed();
            }
            table.sort(c);
        }

        ListIterator<JSONObject> i = table.listIterator();
        while(i.hasNext() && (limit == 0 || limit > idx)){
            JSONObject json = i.next();
            boolean isPassed = true;
            for (Object[] evalCondition : where) {
                isPassed = evalBoolean((Character) evalCondition[1], json.get(evalCondition[0]), evalCondition[2]);
                if (!isPassed) {
                    break;
                }
            }
            if(isPassed){
                if(page > 0){
                    if((page - 1) * DEFAULT_PAGINATION <= i.previousIndex()){
                        if(i.previousIndex() < page * DEFAULT_PAGINATION){
                            json.put("row_num", i.previousIndex());
                            result.add(json);
                            idx++;
                        }else{
                            break;
                        }
                    }
                } else {
                    json.put("row_num", i.previousIndex());
                    result.add(json);
                    idx++;
                }
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

    public BaseDBA join(BaseDBA other_dba, String table_a_column){
        return join(other_dba, table_a_column, table_a_column);
    }

    /**
     * join기능 condition추가 필요
     * @param other_dba
     * @param table_a_column
     * @param table_b_column
     * @return
     */
    public BaseDBA join(BaseDBA other_dba, String table_a_column, String table_b_column){
        BaseDBA joined_dba = new BaseDBA();
        joined_dba.table = new JSONArray();
        JSONArray other_table = (JSONArray) other_dba.table.clone();
        JSONObject this_row, other_row, new_row;
        String casted_key;
        for(int i = table.size() -1; i > -1; i-- ){
            this_row = (JSONObject) table.get(i);
            for(int j = other_table.size() -1; j > -1; j-- ){
                other_row = (JSONObject) other_table.get(j);
                if(this_row.get(table_a_column).toString().equals(other_row.get(table_b_column).toString())){
                    new_row = new JSONObject();
                    for (Object key : this_row.keySet()) {
                        casted_key = (String)key;
                        new_row.put(FILE_NAME+"."+casted_key, this_row.get(casted_key));
                    }
                    for (Object key : other_row.keySet()) {
                        casted_key = (String)key;
                        new_row.put(other_dba.FILE_NAME+"."+casted_key, other_row.get(casted_key));
                    }
                    joined_dba.table.add(new_row);
                    break;
                }
            }
        }
        int idx = 0;
        joined_dba.COLUMN = new String[COLUMN.length + other_dba.COLUMN.length];
        joined_dba.COLUMN_TYPE = new String[COLUMN.length + other_dba.COLUMN.length];
        for (; idx < COLUMN.length; idx++) {
            joined_dba.COLUMN[idx] = FILE_NAME+"."+COLUMN[idx];
            joined_dba.COLUMN_TYPE[idx] = COLUMN_TYPE[idx];
        }
        for (; idx < COLUMN.length + other_dba.COLUMN.length; idx++) {
            joined_dba.COLUMN[idx] = other_dba.FILE_NAME+"."+other_dba.COLUMN[idx - COLUMN.length];
            joined_dba.COLUMN_TYPE[idx] = other_dba.COLUMN_TYPE[idx - COLUMN.length];
        }
        joined_dba.FILE_NAME = FILE_NAME+"_"+other_dba.FILE_NAME;
        return joined_dba;
    }
}
