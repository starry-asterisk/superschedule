package com.toy.superschedule.Service;

import com.toy.superschedule.db.BoardDBA;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.servlet.http.HttpServletRequest;
import java.util.Date;

@Service
public class BoardSVC {
    @Autowired
    BoardDBA d;


    public JSONArray searchList(int page, String title, String author_nickname, String order, int orderASC){

        JSONObject condition = new JSONObject();
        condition.put("limit", d.DEFAULT_PAGINATION);
        Object[][] where = {{"author_nickname",'%',author_nickname},{"title",'%',title}};
        condition.put("where",where);
        condition.put("page",page);
        condition.put("orderBy",order);
        condition.put("orderASC",orderASC);

        return d.find(condition);
    }

    public boolean newBoard(String title, String contents, HttpServletRequest req){

        JSONObject data = new JSONObject();
        JSONObject user = (JSONObject) req.getSession().getAttribute("user");
        data.put("title", title);
        data.put("contents", contents);
        data.put("author", user.get("name"));
        data.put("author_nickname", user.get("nickname"));
        data.put("danger_level", 0);
        data.put("created", new Date().getTime());

        return d.insertOne(data);
    }

}
