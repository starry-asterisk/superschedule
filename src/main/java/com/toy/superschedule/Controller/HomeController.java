package com.toy.superschedule.Controller;

import org.json.simple.JSONObject;
import org.springframework.http.HttpRequest;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.net.http.HttpResponse;

@RestController
public class HomeController {

    @RequestMapping(value= {"/index", "/"})
    public ModelAndView index(HttpServletRequest req, HttpServletResponse res){
        ModelAndView mov = new ModelAndView("index");
        return mov;
    }

    @GetMapping("/error")
    public ModelAndView error(HttpServletRequest req, HttpServletResponse res){
        ModelAndView mov = new ModelAndView("error");
        return mov;
    }

    @PostMapping("/upload")
    public JSONObject upload(HttpServletRequest req, HttpServletResponse res){
        JSONObject r = new JSONObject();
        System.out.println(req.getParameter("title"));
        System.out.println(req.getParameter("description"));
        r.put("result", "it was success");
        return r;
    }
}
