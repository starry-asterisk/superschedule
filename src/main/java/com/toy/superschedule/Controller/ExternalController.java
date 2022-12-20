package com.toy.superschedule.Controller;

import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;

@RestController
@RequiredArgsConstructor
public class ExternalController {
    @GetMapping(value={"/external/{path}"})
    public ModelAndView index(@PathVariable String path){ return new ModelAndView("external/"+path); }
}