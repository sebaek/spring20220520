<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="my" tagdir="/WEB-INF/tags"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.1.1/css/all.min.css" integrity="sha512-KfkfwYDsLkIlwQp6LFnl8zNdLGxu9YAA1QvwINks4PhcElQSvqcyVLLD9aMhXd13uQjoXtEKNosOWaZqXgel0g==" crossorigin="anonymous" referrerpolicy="no-referrer" />
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.1.3/css/bootstrap.min.css" integrity="sha512-GQGU0fMMi238uA+a/bdWJfpUGKUkBdgfFdgBm72SUQ6BeyWjoY/ton0tEjH+OSH9iP4Dfh+7HM0I9f5eR0L/4w==" crossorigin="anonymous" referrerpolicy="no-referrer" />
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js" referrerpolicy="no-referrer"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-ka7Sk0Gln4gmtz2MlQnikT1wXgYsOg+OMhuP+IlRH9sENBO0LRn5q+8nbTov4+1p" crossorigin="anonymous"></script>

<title>Insert title here</title>
<script>
	$(document).ready(function() {
		// 기존 이메일
		const oldEmail = $("#emailInput1").val();
		// 기존 닉네임
		const oldNickName = $("#nickNameInput1").val();
		
		// 이메일 input 요소에 text 변경시 이메일중복확인버튼 활성화
		$("#emailInput1").keyup(function() {
			const newEmail = $("#emailInput1").val();
			
			if (oldEmail === newEmail) {
				$("#emailCheckButton1").attr("disabled", "");
				$("#emailMessage1").text("");
			} else {
				$("#emailCheckButton1").removeAttr("disabled");
			}
			
		});
		
		// 닉네임 input 요소에 text 변경시 닉네임중복확인버튼 활성화
		$("#nickNameInput1").keyup(function() {
			const newNickName = $("#nickNameInput1").val();
			
			if (oldNickName === newNickName) {
				$("#nickNameCheckButton1").attr("disabled", "");
				$("#nickNameMessage1").text("");
			} else {
				$("#nickNameCheckButton1").removeAttr("disabled");
			}
			
		});
		
		// 이메일중복버튼 클릭시 ajax 요청 발생
		$("#emailCheckButton1").click(function(e) {
			// 기본 이벤트 진행 중지
			e.preventDefault();
			
			const data = {email : $("#emailInput1").val()};
			$.ajax({
				url : "${appRoot}/member/check",
				type : "get",
				data : data,
				success : function(data) {
					switch(data) {
					case "ok" :
						$("#emailMessage1").text("사용 가능한 이메일입니다.");
						break;
					case "notOk" :
						$("#emailMessage1").text("사용 불가능한 이메일입니다.");
						break;
					}
				},
				error : function() {
					$("#emailMessage1").text("이메일 중복 확인 중 오류 발생, 다시 시도해주세요.");
				},
				complete : function() {
					console.log("이메일 중복 확인 완료")
				}
			});
		});
		
		// 닉네임중복버튼 클릭시 ajax 요청 발생
		$("#nickNameCheckButton1").click(function(e) {
			// 기본 이벤트 진행 중지
			e.preventDefault();
			
			const data = {nickName : $("#nickNameInput1").val()};
			$.ajax({
				url : "${appRoot}/member/check",
				type : "get",
				data : data,
				success : function(data) {
					switch(data) {
					case "ok" :
						$("#nickNameMessage1").text("사용 가능한 닉네임입니다.");
						break;
					case "notOk" :
						$("#nickNameMessage1").text("사용 불가능한 닉네임입니다.");
						break;
					}
				},
				error : function() {
					$("#nickNameMessage1").text("닉네임 중복 확인 중 오류 발생, 다시 시도해주세요.");
				},
				complete : function() {
					console.log("닉네임 중복 확인 완료")
				}
			});
		});
		
		// 암호, 암호확인 요소 값 변경시
		$("#passwordInput1, #passwordInput2").keyup(function() {
			const pw1 = $("#passwordInput1").val();
			const pw2 = $("#passwordInput2").val();
			
			if (pw1 === pw2) {
				$("#passwordMessage1").text("패스워드가 일치합니다.");
			} else {
				$("#passwordMessage1").text("패스워드가 일치하지 않습니다.");
			}
		});
		
	});
</script>
</head>
<body>
	<my:navBar></my:navBar>
	
	<div>
	아이디 : <input type="text" value="${member.id }" readonly /> <br />
	암호 : <input id="passwordInput1" type="text" value="${member.password }"  /> <br />
	암호확인 : <input id="passwordInput2" type="text" value="${member.password }"  /> <br />
	<p id="passwordMessage1"></p>
	
	이메일 : <input id="emailInput1" type="email" value="${member.email }" /> 
	<button id="emailCheckButton1" disabled>이메일중복확인</button> <br />
	<p id="emailMessage1"></p>
	
	닉네임 : <input id="nickNameInput1" type="text" value="${member.nickName }" /> 
	<button id="nickNameCheckButton1" disabled>닉네임중복확인</button> <br />
	<p id="nickNameMessage1"></p>
	
	가입일시 : <input type="datetime-local" value="${member.inserted }" readonly /> <br />
	</div>
	
	<%-- 요구사항
	1. 이메일 input에 변경 발생시 '이메일중복확인버튼 활성화'
	   ->버튼클릭시 ajax로 요청/응답, 적절한 메시지 출력
	2. 닉네임 input에 변경 발생시 '닉네임중복확인버튼 활성화'
	   ->버튼클릭시 ajax로 요청/응답, 적절한 메시지 출력
	
	3. 암호/암호확인일치, 이메일 중복확인 완료 ,닉네임 중복확인 완료 시에만
	   수정버튼 활성화
	
	 --%>
	
	<div>
	<button disabled>수정</button>
	<button data-bs-toggle="modal" data-bs-target="#modal1">삭제</button>
	</div>
	
	
	<!-- Modal -->
<div class="modal fade" id="modal1" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="exampleModalLabel">Modal title</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body">
	      <form id="form1" action="${appRoot }/member/remove" method="post">
	        <input type="hidden" value="${member.id }" name="id" />
	        암호 : <input type="text" name="password" />
	      </form>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
        <button form="form1" type="submit" class="btn btn-danger">탈퇴</button>
      </div>
    </div>
  </div>
</div>
</body>
</html>








