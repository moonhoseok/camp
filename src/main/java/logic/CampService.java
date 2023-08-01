package logic;

import java.io.File;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.validation.Valid;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import dao.BoardDao;
import dao.CommentDao;
import dao.UserDao;

@Service
public class CampService {

	@Autowired
	private UserDao userDao;
	@Autowired
	private BoardDao boarddao;
	@Autowired
	private CommentDao commentdao;
	
	//파일 업로드 부분
		public void uploadFileCreate(MultipartFile file, String path) {
			// file : 파일의 내용
			// path : 업로드할 폴더
			String orgFile = file.getOriginalFilename(); // 파일이름
			File f = new File(path);
			if(!f.exists())f.mkdirs();
			try {
				//file에 저장된 내용을 파일로 저장.
				file.transferTo(new File(path+orgFile));
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
	public void boardWrite(@Valid Board board, HttpServletRequest request) {
		int maxnum = boarddao.maxNum(); //등록된 게시물의 최대 num값을 리턴
		board.setNum(++maxnum);
		board.setGrp(maxnum);
		if(board.getFile1() != null && !board.getFile1().isEmpty()) {
			String path = request.getServletContext().getRealPath("/")
					+"board/file/";
			this.uploadFileCreate(board.getFile1(), path);
			board.setFileurl(board.getFile1().getOriginalFilename());
		}
		boarddao.insert(board);
	}

	public int boardcount(String boardid,String column, String find) {
		return boarddao.count(boardid,column,find);
	}

	public List<Board> boardlist(Integer pageNum, int limit, String boardid
			,String column, String find) {
		return boarddao.list(pageNum,limit,boardid,column,find);
	}

	public Board getBoard(Integer num) {
		return boarddao.selectOne(num);
	}

	public void addReadcnt(Integer num) {
		boarddao.addReadcnt(num);
	}

	/*public Board boardReply(Map<String,String> param) {
		//boarddao.updateGrpstep(param);
		Board board = new Board();
		int maxnum = boarddao.maxNum(); //등록된 게시물의 최대 num값을 리턴
		int grplevel =(Integer.parseInt(param.get("grplevel")));
		int grpstep = (Integer.parseInt(param.get("grpstep")));
		board.setNum(++maxnum);
		board.setBoardid(param.get("boardid"));
		//board.setNum(Integer.parseInt(param.get("num")));
		board.setGrp(Integer.parseInt(param.get("grp")));
		board.setGrplevel(++grplevel);
		board.setGrpstep(++grpstep);
		board.setWriter(param.get("writer"));
		board.setPass(param.get("pass"));
		board.setTitle(param.get("title"));
		board.setContent(param.get("content"));
		boarddao.insert(board);
		return board;
	}*/
	@Transactional // 중간 오류시 롤백 : 트랜잭션처리함. 업무를 원자화한다. ALL or nothing
	public void boardReply(Board board) {
		boarddao.updateGrpStep(board);  //이미 등록된 grpstep값 1씩 증가
		int max = boarddao.maxNum();    //최대 num 조회
		board.setNum(++max);  //원글의 num => 답변글의 num 값으로 변경
		                      //원글의 grp => 답변글의 grp 값을 동일. 설정 필요 없음
                              //원글의 boardid => 답변글의 boardid 값을 동일. 설정 필요 없음
		board.setGrplevel(board.getGrplevel() + 1); //원글의 grplevel => +1 답변글의 grplevel 설정
		board.setGrpstep(board.getGrpstep() + 1);   //원글의 grpstep => +1 답변글의 grpstep 설정
		boarddao.insert(board);
	}

	public void boardUpdate(Board board, HttpServletRequest request) {
		if(board.getFile1() != null && !board.getFile1().isEmpty()) {
			String path = request.getServletContext().getRealPath("/")
					+"board/file/";
			//파일 업로드 : board.getFile1()의 내용을 파일로 생성
			this.uploadFileCreate(board.getFile1(), path); 
			board.setFileurl(board.getFile1().getOriginalFilename());
		}
		boarddao.update(board);
	}

	public void boardDelete(Integer num) {
		boarddao.delete(num);
	}
	public int commmaxseq(int num) {
		return commentdao.maxseq(num);
	}
	public void comminsert(Comment comm) {
		commentdao.insert(comm);
	}
	public List<Comment> commlist(Integer num) {
		return commentdao.list(num);
	}

	public void commdel(int num, int seq, String pass) {
		commentdao.delete(num, seq, pass);
	}

	public Comment commSelectOne(int num, int seq) {
		return commentdao.selectOne(num, seq);
	}
}
