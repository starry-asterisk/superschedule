package com.toy.superschedule.Service;

import org.json.simple.JSONObject;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import javax.servlet.http.HttpServletRequest;
import java.util.Map;

public class BoardSVC {
    @RequestMapping(method={RequestMethod.GET}, value="/boards")
    public JSONObject list(HttpServletRequest req, @RequestBody Map<String, String> param){
        JSONObject r = new JSONObject();

        System.out.println(param);
        r.put("result", "it was success");
        return r;
    }
    @RequestMapping(method={RequestMethod.POST}, value="/boards")
    public JSONObject add(HttpServletRequest req, @RequestBody Map<String, String> param){
        JSONObject r = new JSONObject();

        System.out.println(param);
        r.put("result", "it was success");
        return r;
    }
    @RequestMapping(method={RequestMethod.PUT}, value="/boards/{id}")
    public JSONObject edit(@PathVariable int id, @RequestBody Map<String, String> param){
        JSONObject r = new JSONObject();

        System.out.println(param);
        r.put("result", "it was success");
        return r;
    }
    @RequestMapping(method={RequestMethod.GET}, value="/boards/{id}")
    public JSONObject detail(@PathVariable int id){
        JSONObject r = new JSONObject();

        System.out.println(id);
        r.put("result", "it was success");
        return r;
    }
    @RequestMapping(method={RequestMethod.DELETE}, value="/boards/{id}")
    public JSONObject delete(@PathVariable int id){
        JSONObject r = new JSONObject();

        System.out.println(id);
        r.put("result", "it was success");
        return r;
    }
}
