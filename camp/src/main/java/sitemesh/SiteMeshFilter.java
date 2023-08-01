package sitemesh;

import java.io.IOException;

import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;

import org.sitemesh.builder.SiteMeshFilterBuilder;
import org.sitemesh.config.ConfigurableSiteMeshFilter;

@WebFilter("/*")
public class SiteMeshFilter extends ConfigurableSiteMeshFilter {
	
	@Override
	public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain filterChain)
			throws IOException, ServletException {
		HttpServletRequest request = (HttpServletRequest) servletRequest;	// request로 변경해서...
		String url = request.getRequestURI();	// 요청 된 url 정보
		if(url.contains("/url/")) url = "user";
		else if (url.contains("/user/")) url = "user";
		else if (url.contains("/board/")) url = "board";
		else if (url.contains("/admin/")) url = "user";
		else if (url.contains("/site/")) url = "site";
		else if (url.contains("/shop/")) url = "shop";
		else if (url.contains("/weather/")) url = "weather";
		else url = "";
		request.setAttribute("url", url);		// 속성 등록
		super.doFilter(servletRequest, servletResponse, filterChain);	// 다음 프로세스 진행
	}

	@Override
	protected void applyCustomConfiguration(SiteMeshFilterBuilder builder) {
		builder.addDecoratorPath("/*", "/layout/camplayout.jsp")
		.addExcludedPath("/user/idchk")
		.addExcludedPath("/user/*search");
		
	}

}
