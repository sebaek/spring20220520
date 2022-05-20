package com.choong.spr.controller.ex01;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.choong.spr.domain.ex01.Products;
import com.choong.spr.mapper.ex01.Ex01Mapper;

@Controller
@RequestMapping("ex01")
public class Ex01Controller {
	
	@Autowired
	private Ex01Mapper mapper;
	
	@RequestMapping("sub01")
	public void listProducts(Model model) {
		List<Products> list = mapper.selectProducts();
		model.addAttribute("list", list);
	}
}
