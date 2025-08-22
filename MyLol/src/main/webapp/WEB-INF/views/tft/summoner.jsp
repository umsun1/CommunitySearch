<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
request.setAttribute("pageType", "lol");
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8" />
    <title>소환사 정보</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/TFT_Info_Styles.css">
    <style>
	    .form-group label {
	    	margin-right: 10px; /* 라벨과 인풋 사이의 간격 조정 */
	    	width: 75px; /* 라벨의 고정 너비 설정 */
		}
		.spinner-box {
			display: none;
			position: fixed;
			top: 0; left: 0; right: 0; bottom: 0;
			background: rgba(0, 0, 0, 0.3);
			z-index: 1000;
			justify-content: center;
			align-items: center;
		}
		body {
		  background-image: url('https://cdn.dak.gg/tft/images2/profile/profile-bg-m.jpg'); /* 실제 이미지 경로로 교체 */
		  background-size: cover;
		  background-repeat: no-repeat;
		  background-position: center center;
		  background-attachment: fixed;
		  
		}
		.white-area{
		  color: white;
		}
	</style>
</head>

<body>
	<h3 class="mt-3 white-area" style="text-align: center; margin-bottom: 35px;">🔍 TFT 전적 상세 조회</h3>
	<div  class="white-area">
		<p>소환사 이름을 <strong>게임이름#태그라인</strong> 형식으로 입력하세요 (예 : 바다새#KR1)</p>
		<form id="summonerForm" class="mt-7 d-flex flex-low">
		    <div >
			    <div class="form-group ">
			        <label for="gameName"><strong>게임 이름 : </strong></label>
			        <input type="text" id="gameName" name="gameName" required>
			    </div>
			    <div class="form-group">
			        <label for="tagLine"><strong>태그라인 : </strong></label>
			        <input type="text" id="tagLine" name="tagLine" required>
			    </div>	    
		    </div>
		    <div class="ml-4 mr-3">
			    <button class="btn-search btn btn-primary" type="submit">조회</button>
		    </div>
		</form>
	</div>
	<div id="summonerProfile" style="margin-top: 20px;">
		<!-- 소환사 정보가 여기에 표시됩니다. -->
	</div>

	<div id="gameInfo" style="margin-top: 20px;">
		<!-- 게임 정보가 여기에 표시됩니다. -->
	</div>
	
	<div class="spinner-box">
		<div class="d-flex justify-content-center align-items-center h-100">
			<div class="spinner-border text-light" role="status">
				<span class="sr-only">로딩중...</span>
			</div>
		</div>
	</div>

	<script type="text/javascript">
		let tacticianData = null;
	    let itemData = null;
	
	    // 전설이와 아이템 등의 json을 미리 한 번만 불러오기
	    Promise.all([
	        fetch("https://ddragon.leagueoflegends.com/cdn/15.16.1/data/en_US/tft-tactician.json").then(res => res.json()),
	        fetch("https://ddragon.leagueoflegends.com/cdn/15.16.1/data/ko_KR/tft-item.json").then(res => res.json()),
	        fetch("https://ddragon.leagueoflegends.com/cdn/15.16.1/data/ko_KR/tft-trait.json").then(res => res.json()),
	        fetch("https://ddragon.leagueoflegends.com/cdn/15.16.1/data/ko_KR/tft-champion.json").then(res => res.json())
	    ]).then(([tacticianRes, itemRes, traitRes, championRes]) => {
	        tacticianData = tacticianRes.data;
	        itemData = itemRes.data;
	        traitData = traitRes.data;
	        championData = championRes.data;
			//console.log(traitData);
				
	        // 데이터를 다 불러온 후, 이제 경기를 출력
			let start = 0;
		    let gameName = "";
		    let tagLine = "";
	    	$('#summonerForm').on('submit', function (e) {
	    		$(".spinner-box").show();
	    		$('#summonerProfile').html('');
			    $('#gameInfo').html('');
		        e.preventDefault();
		        
		        gameName = $('#gameName').val();
		        tagLine = $('#tagLine').val();
		        start = 0; // 처음부터 시작
	
		        // 1. PUUID, Summoner ID 조회
		        $.ajax({
		        	url: '<c:url value="/tft/searchPUUID"/>',
		            method: 'GET',
		            data: { gameName: gameName, tagLine: tagLine },
		            success: function (response) {
		                const puuid = response.puuid;
		                getSummonerProfile(puuid, gameName, tagLine); // 소환사 정보
		                getMatchInfo(puuid, start); // 경기 정보
		                $(".spinner-box").hide();
		            }
		        });
		    });
	      	//더보기 누르면 start +10 해주고 getMatchInfo 호출
	        $(document).on("click", ".btn-more", function () {
	        	$(".spinner-box").show();
	        	start += 10;
	            console.log(start);
	            searchMore(start, gameName, tagLine); // 값 전달
	            
	        });
	    });    
    </script>

	<script type="text/javascript">
	    function searchMore(start, gameName, tagLine) {
	        console.log(gameName);
	    	$.ajax({
	            url: '<c:url value="/tft/searchPUUID"/>',
	            method: 'GET',
	            data: { gameName: gameName, tagLine: tagLine },
	            success: function (response) {
	                const puuid = response.puuid;
	                getMatchInfo(puuid, start);
	                
	            },
				complete: function(){
					$(".spinner-box").hide();
				}
	        });
	    }
    </script>


	<!-- 2. 소환사 정보 출력 함수 -->
	<script type="text/javascript">
	    function getSummonerProfile(puuid, gameName, tagLine) {
	        $.ajax({
	        	async : false,
	            url: '<c:url value="/tft/getSummonerByPuuid"/>',
	            method: 'GET',
	            data: { puuid: puuid },
	            success: function (summonerProfile) {
	                const id = summonerProfile.puuid;
	                const iconId = summonerProfile.profileIconId;
	                const level = summonerProfile.summonerLevel;
	                /* console.log('puuid : ' + puuid + 'iconId : ' + iconId +  'level : '+ level);*/

	                $.ajax({
	                    url: '<c:url value="/tft/getSummonerProfile"/>',
	                    method: 'GET',
	                    data: { puuid : puuid, gameName : gameName, tagLine : tagLine},
	                    success: function (summoner) {
	                    	console.log(summoner);
	                        $('#summonerProfile').html(summoner);
	                    }
	                });
	            }
	        });
	    }
    </script>

	<script type="text/javascript">
   		 // TFT 경기 ID 요청
    	function getMatchInfo(puuid, start) {	 	    
   			$.ajax({
		    	async : false,
		        url: '<c:url value="/tft/recentTftMatchIds"/>',
		        method: 'GET',
		        data: { puuid: puuid, start : start },
		        success: function(matchIds) {
		            if (matchIds.length > 0) {
		                // 경기 정보를 순차적으로 가져오기
		                console.log(matchIds);
		                fetchMatchDetails(matchIds, 0, puuid);
		            } else {
		                $('#summonerMatchInfo').append('<p>최근 경기 데이터가 없습니다.</p>');
		            }
		        },
		        error: function() {
		            $('#summonerMatchInfo').append('<p style="color: red;">경기 ID를 가져오는 중 오류가 발생했습니다.</p>');
		        }
		    });
    	}
   		// 유닛 아이디가 TFT14로 시작하지않으면 14시즌 게임이 아님
    	function isSet14Game(matchInfo) {
    	    return matchInfo.participants.some(p =>
    	        p.units.some(unit => unit.character_id.startsWith("TFT14_"))
    	    );
    	}
    </script>
    
	<script type="text/javascript">
    function fetchMatchDetails(matchIds, index, puuid) {
        if (index >= matchIds.length) return; // 모든 경기를 처리했으면 종료

        var matchId = matchIds[index];
        $.ajax({
        	async : false,
            url: '<c:url value="/tft/matchDetail"/>',
            method: 'GET',
            data: { matchId: matchId },
            success: function(matchDetailResponse) {
                if (matchDetailResponse.error) {
                    $('#summonerMatchInfo').append('<p style="color: red;">경기 ID ' + matchId + ': ' + matchDetailResponse.error + '</p>');
                } else {
                	/* if (!isSet14Game(matchDetailResponse.info)) {
                        console.log("13시즌 경기이므로 제외: " + matchId);
                        $(".btn-more").remove();
                        return;
                    } */
                	
                    var matchDetailHtml = '<div class="infoBox form-control mt-3 mb-3">'
                    
                    ;
                    matchDetailResponse.info.participants.forEach(function(player) {
                        
	                   	// 입력한 유저의 정보만 표시
	                   	if (player.puuid === puuid) {
	              			//전설이 이미지 url
					    	playerUrl ="https://ddragon.leagueoflegends.com/cdn/15.16.1/img/tft-tactician/" + tacticianData[player.companion.item_ID].image.full;
					    	matchDetailHtml += '<h4>#' + player.placement + ' 경기 상세 정보</h4>'+ 
					    						/* '<h5>경기 ID: ' + matchId + '</h5>'+ */
						    				'<div style="display: flex; align-items: center; flex-wrap: nowrap;">'
					    	matchDetailHtml += '<div class="legend ml-3 mt-3" style="display: flex; align-items: center; margin-right: 20px;">'+
													'<figure>'+
														'<img src="' + playerUrl + '" alt="'+ tacticianData[player.companion.item_ID] +'" class="legend"/>'+
														'<span class="level">' + player.level + '</span>'+
													'</figure>'+
												'</div>';
							//시너지
	                   		matchDetailHtml += '<div class="synergy-container" style="display: flex; flex-wrap: wrap; gap: 8px;">';
	
                            const styleBgMap = {
                                1: "https://cdn.dak.gg/tft/images2/tft/traits/background/bronze.svg",
                                2: "https://cdn.dak.gg/tft/images2/tft/traits/background/silver.svg",
                                3: "https://cdn.dak.gg/tft/images2/tft/traits/background/unique.svg",
                                4: "https://cdn.dak.gg/tft/images2/tft/traits/background/gold.svg",
                                5: "https://cdn.dak.gg/tft/images2/tft/traits/background/chromatic.svg"
                            };
	
                            const traitMetaMap = {};
                            for (const key in traitData) {
                                const trait = traitData[key];
                                traitMetaMap[key] = {
                                    name: trait.name,
                                    icon: "https://ddragon.leagueoflegends.com/cdn/15.16.1/img/tft-trait/"+ trait.image.full
                                };
                            }
							//시너지
                            const stylePriority = {
                                3: 1, //유니크
                                5: 2, //프리즘
                                4: 3, //골드
                                2: 4, //실버
                                1: 5  //브론즈
                            };
	
                            const styleName = {
                                1: "브론즈",
                                2: "실버",
                                3: "고유특성",
                                4: "골드",
                                5: "프리즘"
                            };
							//표시해주는 우선순위 설정
                            const filteredTraits = player.traits
                            .filter(trait => trait.tier_current > 0 && trait.style > 0)
                            .sort((a, b) => {
                                    const aPriority = stylePriority[a.style] || 999;
                                    const bPriority = stylePriority[b.style] || 999;
                                    return aPriority - bPriority;
                            });
							//화면에 표시하기
                            filteredTraits.forEach(function(trait) {
                                const meta = traitMetaMap[trait.name];
                                const displayName = meta ? meta.name : trait.name;
                                const imageUrl = meta ? meta.icon : '';
                                const bgUrl = styleBgMap[trait.style] || '';
                                const grade = styleName[trait.style] || '';

                                if (imageUrl) {
                                    matchDetailHtml += 
                                    '<div style="width: 32px; text-align: center;">' + 
                                        '<div style="position: relative; width: 32px; height: 32px;" class="synergy">' +
                                            '<img src="' + bgUrl + '" style="position: absolute; top: 0; left: 0; width: 100%; height: 100%;">' +
                                            '<img src="' + imageUrl + '" alt="' + displayName + '" style="position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%); width: 18px; height: 18px; filter: invert(1);" />' +
                                        	'<div class="tooltip">'+displayName+'('+ trait.num_units +')</div>'+
                                        '</div>' +
                                        /* '<div style="font-size: 12px; margin-top: 2px;">' + trait.num_units + ' ' + displayName + '</div>' + */
                                    '</div>';
                                }
                            });
                            matchDetailHtml += '</div></div>';					
							
												
                           	matchDetailHtml += '<div class="mt-6 mb-3 ml-2">';
                           	
                           	const championMetaMap = {}; //챔피언
                           	const itemDataById = {};	//아이템
                           	for (const key in championData) {
                           	    const champ = championData[key];
                           	    championMetaMap[champ.id] = champ;
                           	}
                           	for (const key in itemData) {
                           	    const item = itemData[key];
                           	    if (item.id) {
                           	        itemDataById[item.id] = item;
                           	    }
                           	}
                           	
                           	matchDetailHtml += '<div class="unit-container">';
                            if (player.units && player.units.length > 0) {
                                player.units.forEach(function(unit) {
	                            	// 소환수는 0 코스트 취급. 테두리는 1코스트처럼 두기.
	                            	if (unit.character_id.startsWith("TFT14_Summon")){unit.rarity = 0;}

								  	// championMetaMap에서 유닛 데이터 찾기
								  	const champMeta = championMetaMap[unit.character_id];
								  	if (!champMeta) {return;} // 매칭 안 되면 스킵
								
								  	const champName = champMeta.name;
								  	
								  	//const champTier = champMeta.tier;
								  	const champImageUrl = "https://ddragon.leagueoflegends.com/cdn/15.16.1/img/tft-champion/" + champMeta.image.full;
		                            	
	                            	var borderColor; //이미지만 감싸는 div 태그에 스타일 넣기 위함
	                            	switch (unit.rarity) {
	                                    case 0: borderColor = 'gray'; break;
	                                    case 1: borderColor = 'lightgreen'; break;
	                                    case 2: borderColor = 'skyblue'; break;
	                                    case 4: borderColor = 'purple'; break;
	                                    case 6: borderColor = 'gold'; break;
	                                    default: borderColor = 'transparent';
	                            	}	
		                            
	                            	matchDetailHtml += '<div class="unit-box mt-3">'+
							                            	//별
							                                '<div class="unit-star">★'+ unit.tier+ '</div>'+
							                                '<div class="unit">'+
							                                	'<div class="unit-image" style="border-color: '+ borderColor + '">'+
		                            							//챔피언
		                            								'<img src="' + champImageUrl + '" class="champ-img " alt="' + champName + '" />'+
                            									'</div>'+
                            									'<div class="tooltip">' + champName + '</div>'+
                            								'</div>'+
                                    						'<div class="unit-items item">';
	                             	// 아이템 이미지들 출력
	                                if (unit.itemNames && unit.itemNames.length > 0) {
	                                    unit.itemNames.forEach(function(itemId) {
	                                        const itemMeta = itemDataById[itemId];
	                                        console.log();
	                                        if (!itemMeta) return;
	                                       	const itemImgUrl = "https://ddragon.leagueoflegends.com/cdn/15.16.1/img/tft-item/" + itemMeta.image.full;;
	                                        //아이템
	                                       	matchDetailHtml += '<div class="item-wrapper">' +
							                                        '<img src="' + itemImgUrl + '" alt="' + itemMeta.name + '" />' +
							                                        '<div class="tooltip">' + itemMeta.name + '</div>' +
						                                    	'</div>';
	                                    });
	                                }
	                                matchDetailHtml += '</div></div>';
                                });
                            } else {
                                matchDetailHtml += '<ol>유닛 정보가 없습니다.</ol>';
                            }
                            matchDetailHtml += '</div>'; 
                            matchDetailHtml += '</div></div>';
                            
		                    $('#gameInfo').append(matchDetailHtml);
                       	}
                   	})
                }
                // 다음 경기 ID로 넘어가기
                fetchMatchDetails(matchIds, index + 1, puuid);

            },
            error: function() {
                $('#gameInfo').append('<p style="color: red;">경기 ID ' + matchId + '의 데이터를 가져오는 중 오류가 발생했습니다.</p>');
                // 다음 경기 ID로 넘어가기
                fetchMatchDetails(matchIds, index + 1, puuid);
            },
            complete: function() {
                $(".btn-more").remove();
                const btn = '<button class="btn btn-outline-success btn-more">더보기</button>';
                $('#gameInfo').append(btn);
            }
        });  
    }
    </script>
</body>
</html>