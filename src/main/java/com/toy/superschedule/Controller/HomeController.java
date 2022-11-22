package com.toy.superschedule.Controller;

import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;

@RestController
@RequiredArgsConstructor
public class HomeController {
    @GetMapping(value={"/index", "/"})
    public ModelAndView index(){ return new ModelAndView("index"); }
    @GetMapping(value="/error")
    public ModelAndView error(){ return new ModelAndView("error"); }
}