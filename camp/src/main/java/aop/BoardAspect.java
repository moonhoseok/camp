package aop;

import javax.servlet.http.HttpSession;

import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Before;
import org.springframework.stereotype.Component;

import exception.LoginException;
import logic.User;

@Component
@Aspect
public class BoardAspect {
	@Before("execution(* controller.Board*.loginCheck*(..)) && args(.., session)")
	public void loginCheck(HttpSession session) throws Throwable {
		User loginUser = (User)session.getAttribute("loginUser");
		// 로그인 여부 검증
		if(loginUser == null) {
			throw new LoginException("[loginCheck] 로그인이 필요합니다.", "../user/login");
		}
	}
}
