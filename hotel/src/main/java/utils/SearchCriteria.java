package utils;

/**
 * 검색 기능이 추가된 테이블 검색 기준 정보
 * page 
 * perPageNum 
 * searchType 
 * keyword
 */
public class SearchCriteria extends Criteria{
	
	/**
	 * 검색 타입
	 * 어떤 컬럼을 기준으로 검색할 건지 사용자가 선택한 컬럼을 저장
	 */
	private String searchType;
	
	/**
	 * 선택된 컬럼(열)에 따라 검색할 단어(키워드)를 저장
	 */
	private String keyword;

	public SearchCriteria() {}

	public SearchCriteria(int page, int perPageNum, 
						  String searchType, String keyword) {
		super(page, perPageNum);
		this.searchType = searchType;
		this.keyword = keyword;
	}

	public String getSearchType() {
		return searchType;
	}

	public void setSearchType(String searchType) {
		this.searchType = searchType;
	}

	public String getKeyword() {
		return keyword;
	}

	public void setKeyword(String keyword) {
		this.keyword = keyword;
	}
	
	/**
	 * SearchCriteria 에 저장된 데이터(필드)를 이용해서
	 * 페이지 이동에 필요한 QueryString 생성 
	 * ?page=1&perPageNum=15&searchType=name&keyword=최기근
	 */
	public String getQuery(int page) {
		StringBuilder sb = new StringBuilder("?");
		sb.append("page=" + page);
		sb.append("&");
		sb.append("perPageNum=" + super.getPerPageNum());
		sb.append("&");
		sb.append("searchType=" + this.searchType);
		sb.append("&");
		sb.append("keyword=" + this.keyword);
		String queryString = sb.toString();
		// delete print
		// System.out.println(queryString);
		return queryString;
	}
	
	@Override
	public String toString() {
		return "SearchCriteria [searchType=" + searchType + ", keyword=" + keyword + ", criteria =" + super.toString()
				+ "]";
	}

}







