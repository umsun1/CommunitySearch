package kr.kh.riot.model.vo;

import java.util.Date;

import lombok.Data;

@Data
public class PositionBoardVO {

	int PB_KEY; 
	int PB_US_KEY; 
	int PB_STATE; 
	String PB_CONTENT; 
	Date PB_TIME, PB_UPD;
}
