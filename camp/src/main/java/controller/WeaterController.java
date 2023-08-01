package controller;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import logic.CampService;

@Controller
@RequestMapping("weather")
public class WeaterController {
	
	@Autowired
	private CampService service;
	
	@GetMapping("*")
	public ModelAndView today() {
		ModelAndView mav = new ModelAndView();
		return mav;
	}
}
