package com.toy.superschedule.Controller;

import com.toy.superschedule.db.BoardDBA;
import com.toy.superschedule.db.FileDBA;
import lombok.RequiredArgsConstructor;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.InputStreamResource;
import org.springframework.core.io.Resource;
import org.springframework.http.ContentDisposition;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import java.io.File;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Date;

@RestController
@RequiredArgsConstructor
public class ImageColtroller {

    @Value("${file.img.path}")
    public String PATH;

    @Autowired
    FileDBA f;

    @RequestMapping(method={RequestMethod.GET}, value="/img/users/{id}")
    public ResponseEntity<Resource> downloadUsersImg(@PathVariable String id) {
        try {
            System.out.println("=======================START========================");
            JSONObject condition = new JSONObject();
            condition.put("limit", 1);
            Object[][] where = {{"folder",'=',"img.users"},{"key",'=',id}};
            condition.put("where",where);

            JSONObject file_db_obj = (JSONObject) f.find(condition).get(0);

            Path path = Paths.get(PATH + "/users/" + file_db_obj.get("name"));
            String contentType = Files.probeContentType(path);

            HttpHeaders headers = new HttpHeaders();
            headers.setContentDisposition(
                    ContentDisposition.builder("attachment")
                            .filename((String) file_db_obj.get("name"), StandardCharsets.UTF_8)
                            .build());
            headers.add(HttpHeaders.CONTENT_TYPE, contentType);

            Resource resource = new InputStreamResource(Files.newInputStream(path));

            return new ResponseEntity<>(resource, headers, HttpStatus.OK);
        } catch (IOException e){
            return  new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
        } catch (Exception e){
            return  new ResponseEntity<>(HttpStatus.BAD_REQUEST);
        }
    }


    @RequestMapping(method={RequestMethod.POST}, value="/img/users")
    public JSONObject uploadUsersImg(HttpServletRequest req, @RequestParam("uploadfile") MultipartFile[] uploadfile) {


        JSONObject result = new JSONObject();

        JSONArray list = new JSONArray();

        JSONObject user = (JSONObject) req.getSession().getAttribute("user");

        for (MultipartFile file : uploadfile) {

            JSONObject data = new JSONObject();
            data.put("owner", user.get("name"));
            data.put("folder", "img.users");
            data.put("key", user.get("name"));
            data.put("created", new Date().getTime());


            data.put("name", new Date().getTime() + "_" + file.getOriginalFilename());
            data.put("size", file.getSize());
            data.put("type", file.getContentType());


            File newFileName = new File(String.valueOf(data.get("name")));

            try {
                file.transferTo(newFileName);
                f.insertOne(data);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return result;
    }
}