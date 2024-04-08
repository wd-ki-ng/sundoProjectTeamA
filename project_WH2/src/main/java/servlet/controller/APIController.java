package servlet.controller;

import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStreamReader;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import servlet.service.APIService;
import servlet.util.Util;

@Controller
public class APIController {

	@Autowired
	private Util util;

	@Resource(name = "APIService")
	private APIService apiService;

	@RequestMapping(value = "/mapTest.do")
	public String mainTest(Model model) throws IOException, ParseException, Exception {
		// DB 데이터 리스트화
		List<EgovMap> sidolist = apiService.sidolist();

		// 모델에 추가
		model.addAttribute("sidolist", sidolist);
		return "main/mapTest";
	}

	@ResponseBody
	@PostMapping(value = "/sgg.do", produces = MediaType.APPLICATION_JSON_VALUE)
	public List<EgovMap> sgg(@RequestParam("sdnm") String sdnm) throws Exception {
		return apiService.sgglist(sdnm);
	}

	@ResponseBody
	@PostMapping(value = "/bjd.do", produces = MediaType.APPLICATION_JSON_VALUE)
	public List<EgovMap> bjd(@RequestParam("sggnm") String sggnm) throws Exception {
		return apiService.bjdlist(sggnm);
	}

	@ResponseBody
	@GetMapping(value = "searchbjd.do")
	public List<EgovMap> searchbjd(@RequestParam("bjdlist") String bjdlist) throws Exception {
		return apiService.searchbjd(bjdlist);
	}

	@ResponseBody
	@GetMapping(value = "searchsgg.do")
	public List<EgovMap> searchsgg(@RequestParam("sggnm") String sggnm) throws Exception {
		return apiService.searchsgg(sggnm);
	}

	@ResponseBody
	@GetMapping(value = "searchsd.do")
	public List<EgovMap> searchsd(@RequestParam("sdnm") String sdnm) throws Exception {
		return apiService.searchsd(sdnm);
	}
	
	@ResponseBody
	@PostMapping(value = "chardata.do")
	public List<EgovMap> chardata(@RequestParam("bjdcd") String bjdcd,
			@RequestParam("chartdate") String chartdate) throws Exception {
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("chartdate",chartdate);
			map.put("bjdcd",bjdcd);
		return apiService.chardata(map);
	}
	
	
	@PostMapping("/read-file.do")
	public @ResponseBody String readfile(@RequestParam("upFile") MultipartFile upFile) throws IOException {

	    
		List<Map<String, Object>> list = new ArrayList<Map<String,Object>>();

		InputStreamReader isr = new InputStreamReader(upFile.getInputStream());
		BufferedReader br = new BufferedReader(isr);

		String line = null;
		int pageSize = 10000;
        int count = 1;
		while ((line = br.readLine()) != null) {
			Map<String, Object> m = new HashMap<String, Object>();
			String[] lineArr = line.split("\\|");
			m.put("usageym", lineArr[0]); // 사용_년월 date
			m.put("sggcd", lineArr[3]); // 시군구_코드 sigungu
			m.put("bjdcd", lineArr[4]); // 법정동_코드 bubjungdong
			m.put("usageamt", Integer.parseInt(lineArr[13])); // 사용_량(KWh) usekwh
			list.add(m);
            if(--pageSize <= 0 ) {
                apiService.upload(list);
                list.clear();
                System.out.println("클리어"+count++);
                pageSize = 10000;
            }
		}
		br.close();
		isr.close();
		
		return "main/mapTest";
	}

}
