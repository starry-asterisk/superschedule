package com.toy.superschedule.Controller;

import com.toy.superschedule.db.BaseDBA;
import com.toy.superschedule.db.BoardDBA;
import com.toy.superschedule.db.UsersDBA;
import lombok.RequiredArgsConstructor;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import java.util.Date;
import java.util.Map;

@RestController
@RequiredArgsConstructor
public class TestController {

    @Autowired
    BoardDBA b;

    @Autowired
    UsersDBA u;
    @RequestMapping(method={RequestMethod.GET}, value="/test/join")
    public JSONArray list(){
        BaseDBA joined_dba = b.join(u, "author", "name");
        JSONObject condition = new JSONObject();
        condition.put("limit", 3);
        Object[][] where = {{"board.contents",'%',"풍요로움"}};
        condition.put("where",where);
        return joined_dba.find(condition);
    }
    @RequestMapping(method={RequestMethod.GET}, value="/test/dummy/boards")
    public void dummyBoard(){
        int count = 0;
        while(count < 100){
            count++;
            JSONObject data = new JSONObject();
            data.put("title", "[TEST_TITLE_"+count+"]");
            data.put("contents", "[TEST TEST TEST TEST TEST]");
            data.put("author", "admin");
            data.put("author_nickname", "관리자");
            data.put("danger_level", "0");
            data.put("created", new Date().getTime());
            b.insertOne(data);
        }
    }
}
