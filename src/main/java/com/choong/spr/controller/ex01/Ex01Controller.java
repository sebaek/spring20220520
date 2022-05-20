package com.choong.spr.controller.ex01;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("ex01")
public class Ex01Controller {
	
	@RequestMapping("sub01")
	public String listProducts(Model model) {
		
	}
}
