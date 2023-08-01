package controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import logic.CampService;
import logic.User;

@Controller
@RequestMapping("user")
public class UserController {
	
	@Autowired
	private CampService service;
	
	@GetMapping("*")
	public ModelAndView main() {
		ModelAndView mav = new ModelAndView();
		mav.addObject(new User());
		return mav;
	}
	
}
