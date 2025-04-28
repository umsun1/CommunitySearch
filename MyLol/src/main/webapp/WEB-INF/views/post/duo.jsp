<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>듀오 모집 게시판</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
    
    
    	<style>
	

		/* 사이드바 */
		.sidebar-l {
  		  position: fixed;
		  top: 7rem;
		  left: 0;
		  width: 12.5rem;
		  height: auto;
		  padding: 1rem;
		  border: 1px solid gray;
		  background: #f9f9f9;
		}
		
		/* 게시판 링크 */
		.board-link, .board-link2 {
		  font-size:1rem;
		  display: block;
		  padding: 8px 10px;
		  margin-bottom: 5px;
		  color: #333;
		  border-radius: 4px;
		  text-decoration: none;
		  transition: all 0.2s;
		}
		
		.board-link:hover, .board-link2:hover, .board-link.active, .board-link.active {
		  background-color: #28a745;
		  color: white;
		}
		@media (min-width: 1200px) {
			.pl-container, .btn-container{
			  margin-left: 7.5rem; 
			  padding: 1rem;
			}
			.pl-container{
			  min-height: 1000px;
			}
		}

	</style>
</head>
<body>
    <div class="container mt-4">
        <h1 class="mt-3">듀오 모집 게시판</h1>
	<!-- 사이드바 -->
		<div class="sidebar-l d-none d-xl-block" id="sidebar-l">
			<h5 class="mt-2 mb-2">-게시판-</h5>
			<a href="#" class="board-link" data-num="0">전체</a>
			<c:choose>
				<c:when test="${not empty boardList}">
					<c:forEach items="${boardList}" var="board">
						<a href="#" class="board-link btn-board" data-num="${board.bo_key}">${board.bo_name}</a>
					</c:forEach>
				    <a class="board-link2" href="<c:url value='/post/duo' />">듀오모집게시판1</a>
				    <a class="board-link2" href="<c:url value='/exampleTFT' />">TFT 배치 툴</a>
				</c:when>
				<c:otherwise>
					<h5>등록된 게시판이 없습니다.</h3>
				</c:otherwise>
			</c:choose>
		</div>


        <div class="text-right mb-3">
            <a href="<c:url value='/post/duo/write' />" class="btn btn-primary">글쓰기</a>
        </div>

        <table class="table table-striped">
            <thead>
                <tr>
                    <th>닉네임</th>
                    <th>티어</th>
                    <th>가고자 하는 라인</th>
                    <th>모스트픽</th>
                    <th>상태</th>
                    <th>관리</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${not empty duoList}">
                        <c:forEach var="duo" items="${duoList}">
                            <tr>
                                <td>${duo.nickname}</td>
                                <td>${duo.tier}</td>
                                <td>${duo.line}</td>
                                <td>${duo.most1}, ${duo.most2}, ${duo.most3}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${duo.status == 'OPEN'}">모집중</c:when>
                                        <c:otherwise>마감</c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <a href="<c:url value='/duo/detail/${duo.id}' />" class="btn btn-sm btn-info">상세보기</a>
                                    <a href="<c:url value='/duo/edit/${duo.id}' />" class="btn btn-sm btn-warning">수정</a>
                                    <a href="<c:url value='/duo/delete/${duo.id}' />" class="btn btn-sm btn-danger" onclick="return confirm('정말 삭제하시겠습니까?');">삭제</a>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <tr>
                            <td colspan="6" class="text-center">등록된 듀오 모집 글이 없습니다.</td>
                        </tr>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>
    </div>

    <footer class="footer mt-5 py-3 bg-light">
        <div class="container text-center">
            <span class="text-muted">© 2025 듀오 모집 게시판</span>
        </div>
    </footer>
</body>
</html>
