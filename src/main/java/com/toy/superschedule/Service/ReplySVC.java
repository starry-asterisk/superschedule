package com.toy.superschedule.Service;

import com.toy.superschedule.db.ReplyDBA;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.servlet.http.HttpServletRequest;
import java.util.Date;
import java.util.Map;

@Service
public class ReplySVC {
    @Autowired
    ReplyDBA r;


    public boolean insertReply(Map<String, String> param, HttpServletRequest req){

        JSONObject data = new JSONObject();
        JSONObject user = (JSONObject) req.getSession().getAttribute("user");
        data.put("board_id", param.get("board_id"));
        data.put("contents", param.getOrDefault("contents","[ERROR_CONTENTS_IS_NULL]"));
        data.put("author", user.get("name"));
        data.put("author_nickname", user.get("nickname"));
        data.put("created", new Date().getTime());

        return r.insertOne(data);
    }

    public int getLastInsertedId() {
        return r.table_increment - 1;
    }

    public Object getListOf(int board_id) {
        JSONObject condition = new JSONObject();
        condition.put("limit", 0);
        Object[][] where = {{"board_id",'=',board_id}};
        condition.put("where",where);
        return r.find(condition);
    }
}
