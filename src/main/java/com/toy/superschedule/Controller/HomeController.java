package com.toy.superschedule.Controller;

import com.toy.superschedule.Service.LoginSVC;
import lombok.RequiredArgsConstructor;
import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;
import javax.servlet.http.HttpServletRequest;
import java.util.Date;
import java.util.Map;

@RestController
@RequiredArgsConstructor
public class HomeController {

    @RequestMapping(method={RequestMethod.GET}, value={"/index", "/"})
    public ModelAndView index(){
        System.out.println(new Date().getTime());
        ModelAndView mov = new ModelAndView("index");
        return mov;
    }

    @RequestMapping(method={RequestMethod.GET}, value="/error")
    public ModelAndView error(){
        ModelAndView mov = new ModelAndView("error");
        return mov;
    }


    @RequestMapping(method={RequestMethod.POST}, value="/upload")
    public JSONObject upload(HttpServletRequest req, @RequestBody Map<String, String> param){
        JSONObject r = new JSONObject();

        System.out.println(param);
        r.put("result", "it was success");
        return r;
    }
}
