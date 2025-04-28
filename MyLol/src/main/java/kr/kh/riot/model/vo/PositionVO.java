package kr.kh.riot.model.vo;

import java.util.Date;
import java.util.List;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Data
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
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
