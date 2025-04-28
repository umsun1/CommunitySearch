package kr.kh.riot.model.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
public class PositionLineVO {
    private int PS_KEY;
    private int PS_PB_KEY;
    private int PS_ORDER;
    private String PS_LINE;
}
