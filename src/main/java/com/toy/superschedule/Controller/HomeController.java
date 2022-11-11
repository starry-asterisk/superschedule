package com.toy.superschedule.Controller;

import org.springframework.http.HttpRequest;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.net.http.HttpResponse;

@Controller
public class HomeController {

    @RequestMapping("/index")
    public ModelAndView index(HttpServletRequest req, HttpServletResponse res){
        ModelAndView mov = new ModelAndView("index");
        mov.addObject("title_added", "it was a joke");
        return mov;
    }

    @GetMapping("/error")
    public ModelAndView error(HttpServletRequest req, HttpServletResponse res){
        ModelAndView mov = new ModelAndView("error");
        mov.addObject("title", "it was a joke");
        return mov;
    }
}
