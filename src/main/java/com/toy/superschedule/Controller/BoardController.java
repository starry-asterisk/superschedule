package com.toy.superschedule.Controller;

import com.toy.superschedule.Service.BoardSVC;
import lombok.RequiredArgsConstructor;
import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import java.util.Map;


@RestController
@RequiredArgsConstructor
public class BoardController {

    @Autowired
    BoardSVC boardSvc;
    @RequestMapping(method={RequestMethod.GET}, value="/boards")
    public JSONObject list(@RequestParam(required = false) Map<String, String> param){
        JSONObject r = new JSONObject();
        r.put("result", boardSvc.searchList(Integer.parseInt(param.getOrDefault("page", "1")), param.getOrDefault("title",""), param.getOrDefault("author_nickname",""), param.getOrDefault("order","id"),Integer.parseInt(param.getOrDefault("orderASC", "-1"))));
        return r;
    }
    @RequestMapping(method={RequestMethod.POST}, value="/boards")
    public JSONObject add(HttpServletRequest req, @RequestBody Map<String, String> param){
        JSONObject r = new JSONObject();
        r.put("result", boardSvc.newBoard(param, req));
        return r;
    }
    @RequestMapping(method={RequestMethod.DELETE}, value="/boards")
    public JSONObject deleteAll(HttpServletRequest req, @RequestBody Map<String, int[]> param){
        JSONObject r = new JSONObject();
        r.put("result", boardSvc.delAll(param.get("ids")));
        return r;
    }
    @RequestMapping(method={RequestMethod.GET}, value="/boards/{id}")
    public ModelAndView detail(@PathVariable int id){
        ModelAndView r = new ModelAndView("boards/detail");
        r.addObject("boards", boardSvc.getDetail(id));
        return r;
    }
    @RequestMapping(method={RequestMethod.PUT}, value="/boards/{id}")
    public JSONObject edit(@PathVariable int id, @RequestBody Map<String, String> param){
        JSONObject r = new JSONObject();

        System.out.println(param);
        r.put("result", "it was success");
        return r;
    }
    @RequestMapping(method={RequestMethod.DELETE}, value="/boards/{id}")
    public JSONObject delete(@PathVariable int id){
        JSONObject r = new JSONObject();
        r.put("result", boardSvc.delOne(id));
        return r;
    }
}
