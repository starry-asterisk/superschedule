package com.toy.superschedule.Util;

import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.Map;
import java.util.StringJoiner;

public class util {
    public static boolean empty(Object v) {
        return (v == null || "".equals(v));
    }

    public static boolean evalBoolean(char operation, Object args1, Object args2) {
        Boolean r = false;
        if(args1 != null && args2 != null){
            long compared_value;
            long standard_value;
            if(args1.getClass().getName().equals("java.lang.String")){
                if(operation == '%'){
                    return args1.toString().contains(args2.toString());
                }
                compared_value = args1.toString().compareTo(args2.toString());
                standard_value = 0;
            }else{
                compared_value = ((Number) args1).longValue();
                standard_value = ((Number) args2).longValue();
            }

            switch (operation) {
                case '<':
                    r = compared_value < standard_value;
                    break;
                case '>':
                    r = compared_value > standard_value;
                    break;
                case '≤':
                    r = compared_value <= standard_value;
                    break;
                case '≥':
                    r = compared_value >= standard_value;
                    break;
                case '=':
                    r = compared_value == standard_value;
                    break;
                case '!':
                    r = compared_value != standard_value;
                    break;
            }
        } else if(operation == '=') {
            r = args1 == args2;
        } else if(operation == '!') {
            r = args1 != args2;
        }
        return r;
    }

    public static String mapToSearch(Map<String, String> map){
        StringJoiner postData = new StringJoiner("&");

        for(Map.Entry<String, String> params: map.entrySet()) {
            postData.add(
                    URLEncoder.encode(params.getKey(), StandardCharsets.UTF_8) +
                    "=" +
                    URLEncoder.encode(String.valueOf(params.getValue()), StandardCharsets.UTF_8)
            );
        }
        return postData.toString();
    }
}
