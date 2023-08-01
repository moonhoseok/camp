package controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import logic.CampService;

@Controller
@RequestMapping("site")
public class SiteController {

	@Autowired
	private CampService service;
	
	@GetMapping("*")
	public ModelAndView detail() {
		ModelAndView mav = new ModelAndView();
		return mav;
	}
	
}
