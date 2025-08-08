    <!-- Footer -->
    <footer class="footer">
        <div class="container">
            <div class="footer-content">
                <div class="footer-section">
                    <h3>고객 서비스</h3>
                    <a href="#">도움말 센터</a>
                    <a href="#">예약 취소</a>
                    <a href="#">연락처</a>
                    <a href="#">FAQ</a>
                </div>
                <div class="footer-section">
                    <h3>회사 정보</h3>
                    <a href="#">회사 소개</a>
                    <a href="#">채용 정보</a>
                    <a href="#">이용약관</a>
                    <a href="#">개인정보처리방침</a>
                </div>
                <div class="footer-section">
                    <h3>파트너</h3>
                    <a href="#">호텔 등록</a>
                    <a href="#">파트너 센터</a>
                    <a href="#">제휴 문의</a>
                </div>
                <div class="footer-section">
                    <h3>소셜 미디어</h3>
                    <a href="#">페이스북</a>
                    <a href="#">인스타그램</a>
                    <a href="#">트위터</a>
                    <a href="#">유튜브</a>
                </div>
            </div>
            <div class="footer-bottom">
                <p>&copy; 2024 Hotel Booking. All rights reserved.</p>
            </div>
        </div>
    </footer>

    <style>
        .footer {
            background: #1a1a1a;
            color: white;
            padding: 3rem 0 1rem;
            margin-top: 4rem;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 2rem;
        }

        .footer-content {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 2rem;
            margin-bottom: 2rem;
        }

        .footer-section h3 {
            color: #2c5aa0;
            margin-bottom: 1rem;
            font-size: 1.2rem;
        }

        .footer-section a {
            display: block;
            color: #ccc;
            text-decoration: none;
            margin-bottom: 0.5rem;
            transition: color 0.3s;
        }

        .footer-section a:hover {
            color: #2c5aa0;
        }

        .footer-bottom {
            border-top: 1px solid #333;
            padding-top: 1rem;
            text-align: center;
            color: #888;
        }

        /* 반응형 디자인 */
        @media (max-width: 768px) {
            .footer-content {
                grid-template-columns: 1fr;
                gap: 1.5rem;
            }
            
            .container {
                padding: 0 1rem;
            }
        }
    </style>
</body>
</html>
