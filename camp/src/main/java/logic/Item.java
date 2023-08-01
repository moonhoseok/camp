package logic;

import java.util.List;

import javax.mail.Multipart;
import javax.validation.constraints.Max;
import javax.validation.constraints.Min;
import javax.validation.constraints.NotEmpty;

import org.springframework.web.multipart.MultipartFile;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class Item {
	private int id;
	@NotEmpty(message="상품 명을 입력하세요.")
	private String name;
	@Min(value=10, message="10원 이상 가능합니다.")
	@Max(value=1000000, message="100만원을 초과할 수 없습니다.")
	private int price;
	@NotEmpty(message="상품에 대한 설명을 입력하세요.")
	private String description;
	private String pictureUrl;
	private MultipartFile picture;
}
