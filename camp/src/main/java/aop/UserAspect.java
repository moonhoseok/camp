package aop;

import javax.servlet.http.HttpSession;

import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Before;
import org.springframework.stereotype.Component;

import exception.LoginException;
import logic.User;

@Component
@Aspect
public class UserAspect {
	
	@Before("execution(* controller.User*.idCheck*(..)) && args(.., id, session)")
	public void idCheck(String id, HttpSession session) throws Throwable {
		User loginUser = (User)session.getAttribute("loginUser");
		// 로그인 여부 검증
		if(loginUser == null) {
			throw new LoginException("[idCheck] 로그인이 필요합니다.", "login");
		}
		// 본인, 관리자 확인
		if(!loginUser.getId().equals("admin") && !loginUser.getId().equals(id)) {
			throw new LoginException("[UserCheck]본인만 가능합니다.", "mypage?id="+loginUser.getId());
		}
	}
	
	@Before("execution(* controller.User*.loginCheck*(..)) && args(.., session)")
	public void loginCheck(HttpSession session) throws Throwable {
		User loginUser = (User)session.getAttribute("loginUser");
		// 로그인 여부 검증
		if(loginUser == null) {
			throw new LoginException("[loginCheck] 로그인이 필요합니다.", "login");
		}
	}
}
