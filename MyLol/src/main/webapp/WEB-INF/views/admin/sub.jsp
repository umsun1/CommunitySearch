<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시글 관리</title>
</head>
<body>

	<c:forEach items="${postList}" var="post">
		<fmt:formatDate var="postTimeDate" pattern="yyyyMMdd" value="${post.po_time}" />
		<fmt:formatDate var="updTimeDate" pattern="yyyyMMdd" value="${post.po_upd}" />

		<div class="form-control input-group d-flex align-items-center" style="min-height:auto; height:auto; margin-bottom:10px;">
			<c:choose>
				<c:when test="${post.po_fi_name ne null}">
					<img alt="" width="100" height="120" src="<c:url value='/download${post.po_fi_name}'/>">
				</c:when>
				<c:otherwise>
					<img width="100" height="120" alt="" src="<c:url value='/resources/img/base.png'/>">
				</c:otherwise>
			</c:choose>

			<div class="ml-3 flex-grow-1">
				<div>
					<c:choose>
						<c:when test="${post.po_upd.time gt now.time}">
							🛠️ [삭제된 글] 
						</c:when>
						<c:otherwise>
							${post.po_title}
						</c:otherwise>
					</c:choose>
				</div>
				<div>작성자 : ${post.po_us_name}</div>
				<div>
					<c:choose>
						<c:when test="${postTimeDate eq today}">
							작성시각 : <fmt:formatDate pattern="HH:mm" value="${post.po_time}" />
						</c:when>
						<c:otherwise>
							작성일 : <fmt:formatDate pattern="yy.MM.dd" value="${post.po_time}" />
						</c:otherwise>
					</c:choose>
					<c:if test="${post.po_time ne post.po_upd}">
						(
						<c:choose>
							<c:when test="${updTimeDate eq today}">
								<fmt:formatDate pattern="HH:mm" value="${post.po_upd}" />
							</c:when>
							<c:otherwise>
								<fmt:formatDate pattern="yy.MM.dd" value="${post.po_upd}" />
							</c:otherwise>
						</c:choose>
						수정됨)
					</c:if>
				</div>
				<div>내용 : ${post.summary}</div>
			</div>

			<!-- 삭제 버튼 추가 -->
			<button type="button" class="btn btn-danger btn-delete ml-2" data-po-key="${post.po_key}">삭제</button>
		</div>
	</c:forEach>

	<c:if test="${postList.size() eq 0}">
		<div class="form-control text-center">등록된 게시글이 없습니다.</div>
	</c:if>

	<!-- 페이지네이션 -->
	<ul class="pagination justify-content-center">
	    <li class="page-item ${!pm.prev ? 'disabled' : ''}">
	        <a class="page-link btn-page" href="#" data-page="${pm.startPage - 1}">이전</a>
	    </li>

	    <c:forEach begin="${pm.startPage}" end="${pm.endPage}" var="i">
	        <li class="page-item ${pm.cri.page == i ? 'active' : ''}">
	            <a class="page-link btn-page" href="#" data-page="${i}">${i}</a>
	        </li>
	    </c:forEach>

	    <li class="page-item ${!pm.next ? 'disabled' : ''}">
	        <a class="page-link btn-page" href="#" data-page="${pm.endPage + 1}">다음</a>
	    </li>
	</ul>

	<script type="text/javascript">
		$(document).off("click", ".btn-page");
		$(document).on("click", ".btn-page", function(e){
		    e.preventDefault();
		    let page = $(this).data("page");
		    cri.page = page;
		    let data = getPostList(cri);
		    $(".pl-container").html(data);
		});

		// 삭제 버튼 이벤트
		$(document).off("click", ".btn-delete");
		$(document).on("click", ".btn-delete", function(e){
			e.preventDefault();
			if(confirm("정말 삭제하시겠습니까?")) {
				let po_key = $(this).data("po-key");

				$.ajax({
					url: "<c:url value='/admin/post/delete'/>",
					type: "post",
					data: { po_key: po_key },
					success: function(response) {
						if(response === "OK") {
							alert("삭제되었습니다.");
							let data = getPostList(cri); // 새로 목록 불러오기
							$(".pl-container").html(data);
						} else {
							alert("삭제 실패했습니다.");
						}
					},
					error: function() {
						alert("서버와 통신 중 오류가 발생했습니다.");
					}
				});
			}
		});
	</script>

</body>
</html>
