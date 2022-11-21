package com.toy.superschedule.Service;

import com.toy.superschedule.db.UsersDBA;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.Map;

@Service
public class LoginSVC {
    @Autowired
    UsersDBA u;

    public JSONObject login(HttpServletRequest req, Map<String, String> param){
        JSONObject condition = new JSONObject();
        condition.put("limit", 1);
        Object[][] where = {{"token",'!',null},{"token",'=',param.get("token")}};
        condition.put("where",where);
        JSONArray r = u.find(condition);
        if(r.toArray().length < 1){
            where = new Object[][]{
                    {"name", '=', param.get("id")},
                    {"pw", '=', param.get("pw")}
            };
            condition.put("where",where);
            r = u.find(condition);
        }
        condition = new JSONObject();
        if(r.toArray().length < 1){
            condition.put("status", 404);
        }else{
            condition.put("status", 200);
            HttpSession session = req.getSession();
            session.setAttribute("user", r.get(0));
        }

        return condition;
    }
}
