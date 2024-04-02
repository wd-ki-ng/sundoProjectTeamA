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
	public String chardata(@RequestParam("bjdcd") String bjdcd,
			@RequestParam("chartdate") String chartdate) throws Exception {
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("chartdate",chartdate);
			map.put("bjdcd",bjdcd);
			String data = apiService.chardata(map);
		return data;
	}
	
	
	@PostMapping("/read-file.do")
	public @ResponseBody String readfile(@RequestParam("upFile") MultipartFile upFile) throws IOException {

		List<Map<String, Object>> list = new ArrayList<>();

		InputStreamReader isr = new InputStreamReader(upFile.getInputStream());
		BufferedReader br = new BufferedReader(isr);

		String line = null;
		while ((line = br.readLine()) != null) {
			Map<String, Object> m = new HashMap<>();
			String[] lineArr = line.split("\\|");
			m.put("usageym", lineArr[0]); // 사용_년월 date
			m.put("land_nm", lineArr[1]); // 대지_위치 addr
			m.put("doro_nm", lineArr[2]); // 도로명_대지_위치 newAddr
			m.put("sgg_cd", lineArr[3]); // 시군구_코드 sigungu
			m.put("bjd_cd", lineArr[4]); // 법정동_코드 bubjungdong
			m.put("land_cd", lineArr[5]); // 대지_구분_코드 addrCode
			m.put("bun", lineArr[6]); // 번 bun
			m.put("si", lineArr[7]); // 지 si
			m.put("nadd", lineArr[8]); // 새주소_일련번호 newAddrCode
			m.put("nadd_roadcd", lineArr[9]); // 새주소_도로_코드 newAddr
			m.put("newaddrabgroundcode", lineArr[10]); // 새주소_지상지하_코드newAddrUnder
			m.put("newaddrmainnum", lineArr[11]); // 새주소_본_번 newAddrBun
			m.put("newaddrsubnum", lineArr[12]); // 새주소_부_번 newAddrBun2
			m.put("usageamt", lineArr[13]); // 사용_량(KWh) usekwh

			list.add(m);
		}
		br.close();
		isr.close();

		apiService.upload(list);

		return "";
	}

}
