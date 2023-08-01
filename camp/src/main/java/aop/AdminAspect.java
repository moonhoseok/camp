package aop;

import javax.servlet.http.HttpSession;

import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.springframework.stereotype.Component;

import exception.LoginException;
import logic.User;

@Component
@Aspect
public class AdminAspect {

	@Around("execution(* controller.AdminController.*(..)) && args(.., session)")
	public Object adminCheck(ProceedingJoinPoint joinPoint, HttpSession session) throws Throwable {
		User loginUser = (User)session.getAttribute("loginUser");
		if(loginUser == null) {
			throw new LoginException("[adminCheck] 로그인이 필요한 서비스입니다.","../user/login");
		} else if(!loginUser.getId().equals("admin")) {
			throw new LoginException("[adminCheck] 관리자만 가능합니다.","../user/mypage?userid="+loginUser.getId());
		}
		return joinPoint.proceed();
	}
	@Around("execution(* controller.CampController.admincheck*(..)) && args(.., session)")
	public Object adminCheck2(ProceedingJoinPoint joinPoint, HttpSession session) throws Throwable {
		User loginUser = (User)session.getAttribute("loginUser");
		if(loginUser == null) {
			throw new LoginException("[adminCheck] 로그인이 필요한 서비스입니다.","../user/login");
		} else if(!loginUser.getId().equals("admin")) {
			throw new LoginException("[adminCheck] 관리자만 가능합니다.","../user/mypage?userid="+loginUser.getId());
		}
		return joinPoint.proceed();
	}
}
