package servlet.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;
import servlet.service.APIService;

@Service("APIService")
public class APIImpl extends EgovAbstractServiceImpl implements APIService{
	
	@Resource(name="APIDAO")
	private APIDAO dao;
	
	@Override
	public List<EgovMap> sidolist() {
		return dao.sidolist();
	}
	
	@Override
	public List<EgovMap> sgglist(String sdnm) {
		return dao.sgglist(sdnm);
	}

	@Override
	public List<EgovMap> bjdlist(String sggnm) { 
		return dao.bjdlist(sggnm);
	}

	@Override
	public List<EgovMap> searchbjd(String bjdlist) {
		return dao.searchbjd(bjdlist);
	}

	@Override
	public List<EgovMap> searchsgg(String sggnm) {
		return dao.searchsgg(sggnm);
	}

	@Override
	public List<EgovMap> searchsd(String sdnm) {
		return dao.searchsd(sdnm);
	}

	@Override
	public void upload(List<Map<String, Object>> list) {
		dao.upload(list);
		
	}

	@Override
	public List<EgovMap> chardata(Map<String, Object> map) {
		return dao.chardata(map);
	}


}
