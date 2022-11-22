package com.toy.superschedule.Controller;

import com.toy.superschedule.Service.LoginSVC;
import lombok.RequiredArgsConstructor;
import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.Map;

@RestController
@RequiredArgsConstructor
public class UserController {
    @Autowired
    LoginSVC loginSvc;

    @RequestMapping(method={RequestMethod.PUT}, value="/users/login")
    public JSONObject login(HttpServletRequest req, @RequestBody Map<String, String> param){
        return loginSvc.login(req, param);
    }

    @RequestMapping(method={RequestMethod.PUT, RequestMethod.GET}, value="/users/logout")
    public JSONObject logout(HttpServletRequest req){
        JSONObject json = new JSONObject();
        json.put("status", 200);
        HttpSession session = req.getSession();
        session.invalidate();
        return json;
    }
}
