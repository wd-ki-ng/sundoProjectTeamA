package servlet.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Repository("APIDAO")
public class APIDAO extends EgovComAbstractDAO {
	
	@Autowired
	private SqlSessionTemplate session;

	public List<EgovMap> sidolist() {
		return selectList("api.sidolist");
	}

	public List<EgovMap> sgglist(String sdnm) {
		return selectList("api.sgglist",sdnm);
	}

	public List<EgovMap> bjdlist(String sggnm) {
		return selectList("api.bjdlist",sggnm);
	}

	public List<EgovMap> searchbjd(String bjdlist) {
		return selectList("api.searchbjd", bjdlist);
	}

	public List<EgovMap> searchsgg(String sggnm) {
		return selectList("api.searchsgg", sggnm);
	}

	public List<EgovMap> searchsd(String sdnm) {
		return selectList("api.searchsd", sdnm);
	}

	public void upload(List<Map<String, Object>> list) {
		insert("api.upload", list);
	}

	public String chardata(Map<String, Object> map) {
		return selectOne("api.chardata", map);
	}

}
