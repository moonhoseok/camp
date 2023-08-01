package logic;

import java.util.Date;

import javax.validation.constraints.Email;
import javax.validation.constraints.Min;
import javax.validation.constraints.NotEmpty;
import javax.validation.constraints.NotNull;
import javax.validation.constraints.Past;
import javax.validation.constraints.Pattern;
import javax.validation.constraints.Size;

import org.springframework.format.annotation.DateTimeFormat;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class User {
	@Pattern(regexp="^[a-zA-Z0-9]*$", message="아이디는 영어와 숫자만 가능합니다.")
	@NotEmpty(message="아이디를 입력하세요")
	private String id;
//	@Pattern(regexp="^(?=.*[a-zA-Z])(?=.*[0-9])(?=.*[!@#$%^&*])[a-zA-Z0-9!@#$%^&*]{8,16}$", message="비밀번호는 영어, 숫자, 특수문자 !,@,#,$,%,^,&,* 가 포함 된 8~16자리 비밀번호여야합니다.")
	@Size(min=8,max=16,message="비밀번호는 8자이상 16자이하로 입력하세요")
	@NotEmpty(message="비밀번호를 입력하세요")
	private String pass;
	@NotEmpty(message="이름을 입력하세요")
	private String name;
	@Past(message="생일은 과거의 날짜만 가능합니다.")
	@DateTimeFormat(pattern="yyyy-MM-dd")
	@NotNull(message="생일을 입력하세요.")
	private Date birth;
	private int gender;
	@NotEmpty(message="email을 입력하세요.")
	@Email(message="이메일 형식을 맞춰주세요")
	private String email;
	@NotEmpty(message="전화번호를 입력하세요")
	@Pattern(regexp = "^\\d{2,3}-\\d{3,4}-\\d{4}$", message = "-을 포함한 숫자만 입력 가능합니다.")
	private String tel;
	
	private Date lastlog;
	private int rest;
	
}
