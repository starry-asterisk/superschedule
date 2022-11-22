package com.toy.superschedule.Controller;

import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;

@RestController
@RequiredArgsConstructor
public class HomeController {

    @RequestMapping(method={RequestMethod.GET}, value={"/index", "/"})
    public ModelAndView index(){
        return new ModelAndView("index");
    }

    @RequestMapping(method={RequestMethod.GET}, value="/error")
    public ModelAndView error(){
        return new ModelAndView("error");
    }
}
