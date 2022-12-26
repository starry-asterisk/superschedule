package com.toy.superschedule.Controller;

import com.toy.superschedule.db.ReplyDBA;
import com.toy.superschedule.db.TokenDBA;
import lombok.RequiredArgsConstructor;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import java.io.*;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

@RestController
@RequiredArgsConstructor
public class ExternalController {

    @Value("${external.webex.client_id}")
    public String WEBEX_CLIENT_ID;
    @Value("${external.webex.client_secret}")
    public String WEBEX_CLIENT_SECRET;

    @Autowired
    TokenDBA t;
    @GetMapping(value={"/external/webex"})
    public ModelAndView webex(HttpServletRequest req, @RequestParam Map<String, String> param) throws Exception {
        ModelAndView mov = new ModelAndView();
        JSONObject data = new JSONObject();
        JSONObject user = (JSONObject) req.getSession().getAttribute("user");
        String user_secret = param.get("code");
        if(user_secret == null){

            JSONObject condition = new JSONObject();
            Object[][] where = {{"owner",'=',user.get("id")},{"type",'=',"webex"}};
            condition.put("where",where);

            JSONArray result = t.find(condition);
            if(result.size() > 0){
                mov.setViewName("external/webex");
                mov.addObject("access_token", ((JSONObject)result.get(0)).get("access_token"));
            }else{
                mov.setViewName("redirect:https://webexapis.com/v1/authorize?client_id="+WEBEX_CLIENT_ID+"&response_type=code&redirect_uri=http%3A%2F%2Flocalhost%2Fexternal%2Fwebex&scope=spark%3Aall%20spark%3Akms");
            }

        }else{

            Map<String, Object> resultMap = new HashMap<String, Object>();
            BufferedReader in = null;

            URL url = new URL("https://webexapis.com/v1/access_token");

            Map<String, String> webex_param = new HashMap<>();

            webex_param.put("grant_type","authorization_code");
            webex_param.put("client_id",WEBEX_CLIENT_ID);
            webex_param.put("client_secret",WEBEX_CLIENT_SECRET);
            webex_param.put("code",user_secret);
            webex_param.put("redirect_uri","http://localhost/external/webex");


            // Map에 담아온 데이터 셋팅해주기
            StringBuilder postData = new StringBuilder();
            for(Map.Entry<String, String> params: webex_param.entrySet()) {
                if(postData.length() != 0) postData.append("&");
                postData.append(URLEncoder.encode(params.getKey(), StandardCharsets.UTF_8));
                postData.append("=");
                postData.append(URLEncoder.encode(String.valueOf(params.getValue()), StandardCharsets.UTF_8));

            }
            byte[] postDataBytes = postData.toString().getBytes(StandardCharsets.UTF_8);

            // url 연결
            HttpURLConnection conn = (HttpURLConnection)url.openConnection();

            //GET방식인지, POST방식인지
            conn.setRequestMethod("POST");

            //받는 API에 따라 맞는 content-Type을 정해주면된다.
            conn.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");

            // content-length로 보내는 데이터의 길이
            conn.setRequestProperty("Content-Length", String.valueOf(postDataBytes.length));

            // 서버에서 온 데이터를 출력할 수 있는 상태인지
            conn.setDoOutput(true);

            // POST 호출
            new DataOutputStream(conn.getOutputStream()).write(postDataBytes);

            in = new BufferedReader(new InputStreamReader(conn.getInputStream(), StandardCharsets.UTF_8));

            String inputLine;
            StringBuilder response = new StringBuilder();
            while((inputLine = in.readLine()) != null) { // response 출력
                response.append(inputLine);
            }

            String jsonStr = response.toString();
            JSONParser parser = new JSONParser();
            resultMap = (Map<String, Object>)parser.parse(jsonStr);


            data.put("owner", user.get("id"));
            data.put("type", "webex");
            data.put("user_secret", user_secret);
            data.put("access_token", resultMap.get("access_token"));
            data.put("access_expired_date", new Date().getTime() + (Long) resultMap.getOrDefault("expires_in",0));
            data.put("refresh_token", resultMap.get("refresh_token"));
            data.put("refresh_expired_date", new Date().getTime() + (Long) resultMap.getOrDefault("refresh_token_expires_in",0));
            data.put("created", new Date().getTime());

            t.insertOne(data);


            mov.setViewName("external/webex");
            mov.addObject("access_token", resultMap.get("access_token"));
        }
        return mov;
    }
}