package servlet.service;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface APIService {

	List<EgovMap> sidolist();
	
	List<EgovMap> sgglist(String sdnm);


	List<EgovMap> bjdlist(String sggnm);

	List<EgovMap> searchbjd(String bjdlist);

	List<EgovMap> searchsgg(String sggnm);

	List<EgovMap> searchsd(String sdnm);

	void upload(List<Map<String, Object>> list);

	String chardata(Map<String, Object> map);



}
