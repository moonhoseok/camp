package logic;

import java.util.ArrayList;
import java.util.List;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class Cart {
	private int itemid;
	private String userid;
	private String name;
	private String pictureUrl;
	private int price;
	private int quantity;

}
