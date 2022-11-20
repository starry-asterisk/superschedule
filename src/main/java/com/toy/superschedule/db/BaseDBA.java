package com.toy.superschedule.db;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.PropertySource;

import java.io.*;
import java.nio.ByteBuffer;
import java.nio.channels.FileChannel;
import java.nio.file.StandardOpenOption;
import java.sql.Timestamp;
import java.util.*;

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
    public int table_increment = 0;

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

                BufferedReader reader = getReader(file);

                table = setLine(reader);
                table_cnt = table.size();

                reader.close();
            } else {
                file.createNewFile();
            }



        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    public String getLine(JSONObject data){
        String insert_string = "";
        Object v;
        for(int i=0;i < COLUMN.length - 1;i++){
            v = data.get(COLUMN[i]);
            if(v != null){
                insert_string += v;
            }else{
                data.put(COLUMN[i], null);
            }
            insert_string +=  DELIMITER;
        }
        v = data.get(COLUMN[COLUMN.length - 1]);
        if(v != null){
            insert_string += v + "\r\n";
        }else{
            data.put(COLUMN[COLUMN.length - 1], null);
        }
        insert_string += "\r\n";
        return insert_string;
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
        ListIterator i = table.listIterator();
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
                json.put("rownum", i.previousIndex());
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

    public boolean insert(JSONObject data) {
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

    public int insert(List<JSONObject> data) {
        Iterator<JSONObject> i = data.iterator();
        int total_cnt = 0;
        try {
            File file = new File(PATH + FILE_NAME + EXTENSION);
            if (file.exists()) {
                BufferedWriter writer = getWriter(file);
                while(i.hasNext()){
                    if(insert(writer, i.next())){
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
        return delete(delete_arr);
    }

    public int delete(JSONArray delete_arr) {
        int cnt = delete_arr.size();
        Iterator<JSONObject> i = delete_arr.iterator();
        while(i.hasNext()){
            table.remove(Integer.parseInt(i.next().get("rownum").toString()));
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

    public int update(Map<String, Object> condition, Map<String, Object> data) {
        return update(condition, data, 0);
    }

    public int update(Map<String, Object> condition, Map<String, Object> data, int limit) {
        return 0;
    }


    public static long scanForString(String text, File file) throws IOException {
        if (text.isEmpty())
            return file.exists() ? 0 : -1;
        // First of all, get a byte array off of this string:
        byte[] bytes = text.getBytes(/* StandardCharsets.your_charset */);

        // Next, search the file for the byte array.
        try (DataInputStream dis = new DataInputStream(new FileInputStream(file))) {

            List<Integer> matches = new LinkedList<>();

            for (long pos = 0; pos < file.length(); pos++) {
                byte bite = dis.readByte();

                for (int i = 0; i < matches.size(); i++) {
                    Integer m = matches.get(i);
                    if (bytes[m] != bite)
                        matches.remove(i--);
                    else if (++m == bytes.length)
                        return pos - m + 1;
                    else
                        matches.set(i, m);
                }

                if (bytes[0] == bite)
                    matches.add(1);
            }
        }
        return -1;
    }

    public static void replaceText(String text, String replacement, File file) throws IOException {
        // Open a FileChannel with writing ability. You don't really need the read
        // ability for this specific case, but there it is in case you need it for
        // something else.
        try (FileChannel channel = FileChannel.open(file.toPath(), StandardOpenOption.WRITE, StandardOpenOption.READ)) {
            long scanForString = scanForString(text, file);
            if (scanForString == -1) {
                // String not found.
                return;
            }
            channel.position(scanForString);
            channel.write(ByteBuffer.wrap(replacement.getBytes(/* StandardCharsets.your_charset */)));
        }
    }
}
