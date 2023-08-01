package config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.scheduling.annotation.EnableScheduling;

import util.CountScheduler;

/*
 *	Scheduling : 정기적인 실행을 하도록 설정 
 * 		초, 분, 시 등의 형태로 작성할 수 있음
 * 		한 번, 매번, 설정해줄 수 있음
 *	@EnableScheduling 	// 스케줄링을 적용할 것이라는 어노테이션
 *	 
 */

@Configuration
@EnableScheduling				// 이거 막으면 스케줄링 안 됨
public class BatchConfig {
	@Bean
	public CountScheduler countScheduler() {
		return new CountScheduler();		// Scheduler 클래스의 설정대로 자동으로 프로그램이 실행하게 됨.
		// util.CountScheduler에 있는
	}
}
