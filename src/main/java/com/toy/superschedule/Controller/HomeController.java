package com.toy.superschedule.Controller;

import com.toy.superschedule.Service.LoginSVC;
import com.toy.superschedule.db.BaseDBA;
import com.toy.superschedule.db.BoardDBA;
import com.toy.superschedule.db.FileDBA;
import com.toy.superschedule.db.UsersDBA;
import lombok.RequiredArgsConstructor;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpRequest;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.net.http.HttpResponse;
import java.util.Map;

@RestController
@RequiredArgsConstructor
public class HomeController {

    @Autowired
    LoginSVC loginSvc;

    @RequestMapping(method={RequestMethod.GET}, value={"/index", "/"})
    public ModelAndView index(HttpServletRequest req, HttpServletResponse res){
        ModelAndView mov = new ModelAndView("index");
        return mov;
    }

    @RequestMapping(method={RequestMethod.GET}, value="/error")
    public ModelAndView error(HttpServletRequest req, HttpServletResponse res){
        ModelAndView mov = new ModelAndView("error");
        return mov;
    }

    @RequestMapping(method={RequestMethod.POST}, value="/login")
    public JSONObject login(HttpServletRequest req, @RequestBody Map<String, String> param){
        return loginSvc.login(req, param);
    }

    @RequestMapping(method={RequestMethod.POST}, value="/upload")
    public JSONObject upload(HttpServletRequest req, @RequestBody Map<String, String> param){
        JSONObject r = new JSONObject();

        System.out.println(param);
        r.put("result", "it was success");
        return r;
    }
}
