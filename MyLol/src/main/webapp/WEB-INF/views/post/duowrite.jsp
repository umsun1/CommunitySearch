<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>듀오 모집 글쓰기</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
</head>
<body>
    <div class="container mt-4">
        <h1 class="mb-4">듀오 모집 글 작성</h1>

        <form action="<c:url value='/duo/write' />" method="post">
            <div class="form-group">
                <label>게시글 내용</label>
                <textarea class="form-control" name="PB_CONTENT" rows="5" required></textarea>
            </div>

            <div class="form-group">
                <label>가고자 하는 라인 선택 (최대 2개)</label>
                <select class="form-control" name="PS_LINE1" required>
                    <option value="">- 1순위 라인 선택 -</option>
                    <option value="탑">탑</option>
                    <option value="정글">정글</option>
                    <option value="미드">미드</option>
                    <option value="원딜">원딜</option>
                    <option value="서포터">서포터</option>
                </select>

                <select class="form-control mt-2" name="PS_LINE2">
                    <option value="">- 2순위 라인 선택(선택사항) -</option>
                    <option value="탑">탑</option>
                    <option value="정글">정글</option>
                    <option value="미드">미드</option>
                    <option value="원딜">원딜</option>
                    <option value="서포터">서포터</option>
                </select>
            </div>

            <button type="submit" class="btn btn-primary mt-3">작성 완료</button>
        </form>
    </div>

    <footer class="footer mt-5 py-3 bg-light">
        <div class="container text-center">
            <span class="text-muted">© 2025 듀오 모집 게시판</span>
        </div>
    </footer>
</body>
</html>
