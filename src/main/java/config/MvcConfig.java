package config;

import java.util.Properties;

import org.springframework.context.MessageSource;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.EnableAspectJAutoProxy;
import org.springframework.context.support.ResourceBundleMessageSource;
import org.springframework.web.multipart.MultipartResolver;
import org.springframework.web.multipart.commons.CommonsMultipartResolver;
import org.springframework.web.servlet.HandlerMapping;
import org.springframework.web.servlet.ViewResolver;
import org.springframework.web.servlet.config.annotation.DefaultServletHandlerConfigurer;
import org.springframework.web.servlet.config.annotation.EnableWebMvc;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;
import org.springframework.web.servlet.handler.SimpleMappingExceptionResolver;
import org.springframework.web.servlet.mvc.method.annotation.RequestMappingHandlerMapping;
import org.springframework.web.servlet.view.InternalResourceViewResolver;


@Configuration        // 환경 설정 파일임을 알려줌. 기존 xml 방식의 설정을 대신하는 자바클래스
@ComponentScan(basePackages = {"controller", "logic", "dao", "aop", "websocket","util"})
// └ xml의 <context:component-scan base-package="controller,logic,dao,aop,websocket" />
@EnableAspectJAutoProxy    // AOP 관련 어노테이션 적용(사용) 할 것
@EnableWebMvc    // 유효성 검증할 것
public class MvcConfig implements WebMvcConfigurer {

    // 기본 웹파일 처리를 위한 설정
    @Override
    public void configureDefaultServletHandling(DefaultServletHandlerConfigurer configurer) {
        configurer.enable();
    }

    @Bean
    public HandlerMapping handlerMapping() {    // 요청 url을 처리
        RequestMappingHandlerMapping hm = new RequestMappingHandlerMapping();
        hm.setOrder(0);
        return hm;
    }

    @Bean
    public ViewResolver vieResolver() {        // view 결정자
        InternalResourceViewResolver vr = new InternalResourceViewResolver();
        vr.setPrefix("/WEB-INF/view/");
        vr.setSuffix(".jsp");
        return vr;
    }

    @Bean
    // 오류 메시지에 해당하는 message.properties 파일의 코드값을 이용해서 메시지를 처리하겠다.
    public MessageSource messageSource() {
        ResourceBundleMessageSource ms = new ResourceBundleMessageSource();
        ms.setBasename("messages");
        return ms;
    }

    @Bean    // 파일 업로드를 위한 설정 - 파라미터나 이름 등을 알아서 집어 넣어줌
    public MultipartResolver multipartResolver() {
        CommonsMultipartResolver mr = new CommonsMultipartResolver();
        mr.setMaxInMemorySize(10485760);    // 업로드시 메모리 가능 크기 설정
        mr.setMaxUploadSize(10485760);    // 업로드 가능한 최대 사이즈 지정
        return mr;
        // 작게 만들면 성능은 떨어지지만, 메인 메모리를 넉넉하게 사용 가능
        // 크게 만들면 성능은 좋지만, 메인 메모리가 부족함
    }

    @Bean    // 예외처리 부분
    public SimpleMappingExceptionResolver exceptionHandler() {
        SimpleMappingExceptionResolver ser = new SimpleMappingExceptionResolver();
        Properties pr = new Properties();
        // 발생되는 예외 클래스						┌ 예외 발생 시 호출 되는 view단
        pr.put("exception.CartEmptyException", "exception");
        pr.put("exception.LoginException", "exception");
        pr.put("exception.BoardException", "exception");
        ser.setExceptionMappings(pr);
        return ser;
    }

    // 인터셉터 관련 설정 - boardInterceptor 만든 거
    // login 안 했거나, admin이 아니면 로그인이 필요하다... 하는 부분
//    @Override
//    public void addInterceptors(InterceptorRegistry registry) {
//        registry.addInterceptor(new BoardInterceptor()).addPathPatterns("/board/write")
//                .addPathPatterns("/board/update")
//                .addPathPatterns("/board/delete")
//                .addPathPatterns("/board/write");
//    }

}
