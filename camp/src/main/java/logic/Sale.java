package logic;

import java.util.Date;
import java.util.List;

import javax.validation.constraints.NotEmpty;

import org.springframework.beans.factory.annotation.Autowired;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class Sale {
	
	@Autowired
	private CampService service;
	
	private int saleid;
	private String userid;
	private int itemid;
	private String name;
	private int quantity;
	private int price;
	private String pictureUrl;
	private int postcode;
	private String address;
	private String detailAddress;
	private Date saledate;
	
}
