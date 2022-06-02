package com.choong.spr.service;

import java.io.File;
import java.io.IOException;
import java.util.List;

import javax.annotation.PostConstruct;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.PropertySource;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import com.choong.spr.domain.BoardDto;
import com.choong.spr.mapper.BoardMapper;
import com.choong.spr.mapper.ReplyMapper;

import software.amazon.awssdk.auth.credentials.AwsCredentialsProvider;
import software.amazon.awssdk.auth.credentials.DefaultCredentialsProvider;
import software.amazon.awssdk.core.sync.RequestBody;
import software.amazon.awssdk.regions.Region;
import software.amazon.awssdk.services.s3.S3Client;
import software.amazon.awssdk.services.s3.model.DeleteObjectRequest;
import software.amazon.awssdk.services.s3.model.ObjectCannedACL;
import software.amazon.awssdk.services.s3.model.PutObjectRequest;

@Service
@PropertySource("classpath:aws.properties")
public class BoardService {

	@Autowired
	private BoardMapper mapper;

	@Autowired
	private ReplyMapper replyMapper;

	/* aws s3 client */
	private S3Client s3client;

	@PostConstruct
	public void init() {
		AwsCredentialsProvider credentialsProvider = DefaultCredentialsProvider.builder().build();
		this.s3client = S3Client.builder()
				.credentialsProvider(credentialsProvider)
				.region(Region.AP_NORTHEAST_2)
				.build();
		System.out.println(s3client);
	}

	public List<BoardDto> listBoard(String type, String keyword) {
		// TODO Auto-generated method stub
		return mapper.selectBoardAll(type, "%" + keyword + "%");
	}

	@Transactional
	public boolean insertBoard(BoardDto board, MultipartFile file) {
		//		board.setInserted(LocalDateTime.now());

		// 게시글 등록
		int cnt = mapper.insertBoard(board);

		// 파일 등록 
		if (file.getSize() > 0) {
			mapper.insertFile(board.getId(), file.getOriginalFilename());
			saveFileInAwsS3(board.getId(), file);
		}

		return cnt == 1;
	}

	private void saveFile(int id, MultipartFile file) {
		// 디렉토리 만들기
		String pathStr = "C:/imgtmp/board/" + id + "/";
		File path = new File(pathStr);
		path.mkdirs();

		// 작성할 파일
		File des = new File(pathStr + file.getOriginalFilename());

		try {
			// 파일 저장
			file.transferTo(des);
		} catch (IllegalStateException | IOException e) {
			e.printStackTrace();
			throw new RuntimeException(e);
		}

	}

	private void saveFileInAwsS3(int id, MultipartFile file) {
		String key = "board/" + id + "/" + file.getOriginalFilename(); 
//		s3client.putObject(awsS3BucketName, "board", file.getInputStream());
		PutObjectRequest por = PutObjectRequest.builder()
				.acl(ObjectCannedACL.PUBLIC_READ)
				.bucket("prj0207")
				.key(key)
				.build();
		try {
			RequestBody rb = RequestBody.fromInputStream(file.getInputStream(), file.getSize());
			s3client.putObject(por, rb);
		} catch (Exception e) {
			e.printStackTrace();
			throw new RuntimeException(e);
		}
	}

	public BoardDto getBoardById(int id) {
		// TODO Auto-generated method stub
		return mapper.selectBoardById(id);
	}

	public boolean updateBoard(BoardDto dto) {
		// TODO Auto-generated method stub
		return mapper.updateBoard(dto) == 1;
	}

	@Transactional
	public boolean deleteBoard(int id) {
		// 파일 목록 읽기
		String fileName = mapper.selectFileByBoardId(id);

		// 실제파일 삭제
		String key = "board/" + id + "/" + fileName; 
		removeFileS3(key);
//		if (fileName != null && !fileName.isEmpty()) {
//			String folder = "C:/imgtmp/board/" + id + "/";
//			String path = folder + fileName;
//
//			File file = new File(path);
//			file.delete();
//
//			File dir = new File(folder);
//			dir.delete();
//		}

		// 파일테이블 삭제
		mapper.deleteFileByBoardId(id);

		// 댓글테이블 삭제
		replyMapper.deleteByBoardId(id);

		return mapper.deleteBoard(id) == 1;
	}

	private void removeFileS3(String key) {
		DeleteObjectRequest dor = DeleteObjectRequest.builder()
				.bucket("prj0207")
				.key(key)
				.build();
		s3client.deleteObject(dor);
	}

}
