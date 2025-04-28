package kr.kh.riot.model.vo;

import java.util.Date;
import java.util.List;

import lombok.Data;

@Data
public class PositionVO {
    // position_board
    private int PB_KEY;
    private int PB_US_KEY;
    private int PB_STATE;
    private String PB_CONTENT;
    private Date PB_TIME;
    private Date PB_UPD;
    
    private List<PositionLineVO> positionLineList;
}
