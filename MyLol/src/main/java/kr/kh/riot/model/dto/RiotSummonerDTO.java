package kr.kh.riot.model.dto;

import lombok.Data;

@Data
public class RiotSummonerDTO {
	private String puuid;
	private int profileIconId;
	private long revisionDate;
	private long summonerLevel;
}
