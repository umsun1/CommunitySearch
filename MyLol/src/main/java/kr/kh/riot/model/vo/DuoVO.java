package kr.kh.riot.model.vo;

import lombok.Data;

@Data
public class DuoVO {
    private int id;
    private String nickname;
    private String tier;
    private String line;
    private String most1;
    private String most2;
    private String most3;
    private String status; // OPEN 또는 CLOSED
}
