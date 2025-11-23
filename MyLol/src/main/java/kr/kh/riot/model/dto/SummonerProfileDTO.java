package kr.kh.riot.model.dto;

import lombok.Data;

@Data
public class SummonerProfileDTO {
	private String puuid;
	private String leagueId;
	private String queueType;
	private String ratedTier;
	private int ratedRating;
	private String tier;
	private String rank;
	private int leaguePoints;
	private int wins;
	private int losses;	
}
