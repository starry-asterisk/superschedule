package com.toy.superschedule.Controller;

import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;

@RestController
@RequiredArgsConstructor
public class HomeController {

    @RequestMapping(method={RequestMethod.GET}, value={"/index", "/"})
    public ModelAndView index(){
        ModelAndView mov = new ModelAndView("index");
        return mov;
    }

    @RequestMapping(method={RequestMethod.GET}, value="/error")
    public ModelAndView error(){
        ModelAndView mov = new ModelAndView("error");
        return mov;
    }
}
