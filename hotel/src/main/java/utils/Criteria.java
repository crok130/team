package utils;
/**
 * table에서 검색할 행정보를 
 * 페이징 처리에 따라 기준을 잡아주는 class
 */
public class Criteria {

	/**
	 * 현재 게시물 목록 페이지 에서 사용자가 요청 페이지 번호
	 */
	private int page;
	
	/**
	 * 한 페이지에 출력할 행(게시물) 개수
	 */
	private int perPageNum;
	
	public Criteria() {
		this(1, 10);
	}
	
	public Criteria(int page, int perPageNum) {
		setPage(page);
		setPerPageNum(perPageNum);
	}

	public int getPage() {
		return page;
	}

	public void setPage(int page) {
		if(page <= 0) {
			this.page = 1;
			return;
		}
		this.page = page;
	}

	public int getPerPageNum() {
		return perPageNum;
	}

	public void setPerPageNum(int perPageNum) {
		if(perPageNum <= 0 || perPageNum > 100) {
			this.perPageNum = 10;
			return;
		}
		this.perPageNum = perPageNum;
	}
	
	/**
	 * @return 게시물 검색 시작 row(행) index 번호 
	 * OFFSET 시작인덱스 번호 ROWS FETCH NEXT 검색개수 ROWS ONLY
	 */
	public int getStartRow() {
		return (this.page - 1) * this.perPageNum;
	}
	

	@Override
	public String toString() {
		return "Criteria [page=" + page + ", perPageNum=" + perPageNum + ", start row="+getStartRow()+" ]";
	}
	
}








