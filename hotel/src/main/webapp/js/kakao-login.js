// 카카오 OAuth2 로그인 스크립트
(function() {
    'use strict';
    
    // 카카오 SDK 초기화
    function initKakaoSDK() {
        if (typeof Kakao !== 'undefined') {
            Kakao.init('YOUR_KAKAO_APP_KEY'); // 여기에 실제 카카오 앱 키를 입력하세요
            console.log('카카오 SDK 초기화 완료');
        } else {
            console.error('카카오 SDK가 로드되지 않았습니다.');
        }
    }
    
    // 카카오 로그인 함수
    function loginWithKakao() {
        if (typeof Kakao === 'undefined') {
            alert('카카오 SDK가 로드되지 않았습니다.');
            return;
        }
        
        Kakao.Auth.login({
            success: function(authObj) {
                console.log('카카오 로그인 성공:', authObj);
                
                // 사용자 정보 가져오기
                Kakao.API.request({
                    url: '/v2/user/me',
                    success: function(res) {
                        console.log('사용자 정보:', res);
                        
                        // 서버로 사용자 정보 전송
                        sendUserInfoToServer(res, authObj.access_token);
                    },
                    fail: function(error) {
                        console.error('사용자 정보 가져오기 실패:', error);
                        alert('사용자 정보를 가져오는데 실패했습니다.');
                    }
                });
            },
            fail: function(err) {
                console.error('카카오 로그인 실패:', err);
                alert('카카오 로그인에 실패했습니다.');
            }
        });
    }
    
    // 서버로 사용자 정보 전송
    function sendUserInfoToServer(userInfo, accessToken) {
        const userData = {
            id: userInfo.id,
            email: userInfo.kakao_account.email,
            nickname: userInfo.properties.nickname,
            profileImage: userInfo.properties.profile_image,
            accessToken: accessToken
        };
        
        fetch('/kakao-login', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify(userData)
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                alert('로그인 성공!');
                window.location.href = data.redirectUrl || '/';
            } else {
                alert('로그인 처리 중 오류가 발생했습니다.');
            }
        })
        .catch(error => {
            console.error('서버 통신 오류:', error);
            alert('서버와의 통신 중 오류가 발생했습니다.');
        });
    }
    
    // 카카오 로그아웃
    function logoutFromKakao() {
        if (typeof Kakao !== 'undefined' && Kakao.Auth.getAccessToken()) {
            Kakao.Auth.logout(function() {
                console.log('카카오 로그아웃 완료');
                window.location.href = '/logout';
            });
        }
    }
    
    // 카카오 계정 연결 해제
    function unlinkKakao() {
        if (typeof Kakao !== 'undefined') {
            Kakao.API.request({
                url: '/v1/user/unlink',
                success: function(res) {
                    console.log('카카오 계정 연결 해제 완료:', res);
                    alert('카카오 계정 연결이 해제되었습니다.');
                    window.location.href = '/logout';
                },
                fail: function(err) {
                    console.error('카카오 계정 연결 해제 실패:', err);
                    alert('카카오 계정 연결 해제에 실패했습니다.');
                }
            });
        }
    }
    
    // 사용자 정보 가져오기
    function getKakaoUserInfo() {
        if (typeof Kakao !== 'undefined') {
            Kakao.API.request({
                url: '/v2/user/me',
                success: function(res) {
                    console.log('현재 사용자 정보:', res);
                    return res;
                },
                fail: function(err) {
                    console.error('사용자 정보 가져오기 실패:', err);
                }
            });
        }
    }
    
    // 토큰 유효성 검사
    function checkKakaoToken() {
        if (typeof Kakao !== 'undefined') {
            if (Kakao.Auth.getAccessToken()) {
                console.log('카카오 토큰이 존재합니다.');
                return true;
            } else {
                console.log('카카오 토큰이 없습니다.');
                return false;
            }
        }
        return false;
    }
    
    // 전역 함수로 노출
    window.KakaoLogin = {
        init: initKakaoSDK,
        login: loginWithKakao,
        logout: logoutFromKakao,
        unlink: unlinkKakao,
        getUserInfo: getKakaoUserInfo,
        checkToken: checkKakaoToken
    };
    
    // DOM이 로드되면 초기화
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', initKakaoSDK);
    } else {
        initKakaoSDK();
    }
    
})(); 