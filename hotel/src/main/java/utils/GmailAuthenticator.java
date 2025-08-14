package utils;

import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.util.Properties;

import jakarta.mail.Authenticator;
import jakarta.mail.PasswordAuthentication;

/**
 * 메일서버에 인증할 사용자 정보를 제공하는 class
 */
public class GmailAuthenticator extends Authenticator{
	
	private final String user;       // 메일 계정
	private final String password;   // 메일 계정 앱 비밀번호
	
	public GmailAuthenticator() {
		Properties prop = new Properties();
		try {
			// .properties 파일의 key value 데이터를 읽어서 저장
			// GmailAuthenticator class 위치를 기준으로 파일 검색
			String path = GmailAuthenticator.class.getResource("../gmail.properties").getPath();
			System.out.println(path);
			prop.load(new FileReader(path));
		} catch (IOException e) {
			e.printStackTrace();
		}
		this.user = prop.getProperty("user");
		this.password = prop.getProperty("password");
	}

	@Override
	protected PasswordAuthentication getPasswordAuthentication() {
		// 비밀번호 포함 사용자 인증 정보(발신자 이메일, 비밀번호)를 제공 하는 class
		return new PasswordAuthentication(this.user, this.password);
	}
	
	// 사용자 이메일 반환
	public String getUser() {
		return this.user;
	}
	
	public Properties getProps() {
		// SMTP 서버 설정
		// 메일 서버에 필요한 설정 정보를 저장할 Properties 객체 생성
		Properties prop = new Properties();
		// SMTP 서버 주소(Gmail)
		prop.setProperty("mail.smtp.host", "smtp.gmail.com");
		// TLS 보안 포트로 연결 587(권장 포트 번호)
		prop.setProperty("mail.smtp.port", "587");
		// SMTP 서버 인증 필요 여부 
		prop.setProperty("mail.smtp.auth", "true");
		// STARTTLS 명령을 사용하여 TLS 암호화 연결 사용 여부 지정
		prop.setProperty("mail.smtp.starttls.enable", "true");
		return prop;
	}
}










