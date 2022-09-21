# FutureDiary
</br>

## 9/13 
   - 완료된 기능
      - 미래일기, 현재 일기 realm filter로 구분해 현재 시간에 맞는 것만 표시해주기
      - 대략적인 layout
      - sideMenuView
      - 다크모드 대응
      - 캘린더 선택시 날짜에 맞는 데이터만 필터해서 보여주기
      - 보관함 뷰 생성 및 기능 구현
      - 검색 뷰 생성 및 기능 구현( title 검색했을 시 검색된 text 색상 변경해주기 완료, 내용도 할지 고민중)
      - 도착 예정 편지 갯수 토스트 띄워주기
         </br>
         
   - 남은 것: 
      - 수정하고 업데이트 시 셀이 하나 더 추가되는 오류⚠️
      - 설정한 미래일기 오는 시점에 맞게 notification 보내주기 및 유저에게 알림푸쉬 권한 요청하기
      - 다국어 지원
      - 전반적인 유저 사용성 증진(textfiled first responder, 키보드 탭 제스쳐, 줄 내릴시 키보드가 가리는 문제 해결)⚠️
      - 설정창(복구/ 백업)
      - 일기를 작성한 캘린더 날짜에 표시해서 유저가 알기 쉽게 해주기
      - 레이아웃 토대에 맞게 UI개선
      - 삭제하기 기능⚠️
      </br>
      
## 9/14
   - 삭제하기 기능 완료
   - 업데이트 기능 완료
   - 미래일기에 설정한 시간에 맞게 notification을 보내줌(foreground, background) 전부
   - 앱 실행시 유저에게 알림푸쉬 권한 요청하기
   
   - 남은 것
      - 다국어 지원
      - 전반적인 유저 사용성 증진(textfiled first responder, 키보드 탭 제스쳐, 줄 내릴시 키보드가 가리는 문제 해결)⚠️
      - 설정창(복구/ 백업)
      - 일기를 작성한 캘린더 날짜에 표시해서 유저가 알기 쉽게 해주기
      - 레이아웃 토대에 맞게 UI개선
      
## 9/15
   - 업데이트 기능 수정 완료
   - 컬렉션뷰에 날짜에 맞게 헤더 보여주기 완료
   
   - 남은것
      - 다국어 지원
      - 전반적인 유저 사용성 증진(textfiled first responder, 키보드 탭 제스쳐, 줄 내릴시 키보드가 가리는 문제 해결)⚠️
      - 설정창(복구/ 백업)
      - 일기를 작성한 캘린더 날짜에 표시해서 유저가 알기 쉽게 해주기
      - 레이아웃 토대에 맞게 UI개선
      - 노티를 눌렀을 때 Collectionview reoload 해주기⚠️
      - collection 헤더뷰 dictionary sort 해주기⚠️
      
## 9/16
   - 컬렉션뷰에 날짜에 맞게 헤더 날짜 최신순으로 맞게 보여주게 수정 완료 -> sort 사용
   - notification을 눌렀을 때 view reload 해주기 완료 -> user notification didReceive 로직사용
   - 내용으로도 검색할 수 있게 해줌
   - textfiled에 first responder 적용
   - iqkeybord 매니저 사용하여 키보드가 텍스트를 가리지 않게해줌
   - textView에 placeholder 추가해줌
   
   - 남은것
      - 전채뷰애서 cell을 삭제하면 오류 발생(realm 관련)
      - 다국어 지원
      - 설정창(복구/ 백업)
      - 레이아웃 토대에 맞게 UI개선
      - iqkeybord매니저를 사용할 때 navigationbar에 침범하는 오류  -> 레이아웃 문제가 아닌 navigation color가 없었던 문제였음
      - 일기를 작성한 캘린더 날짜에 표시해서 유저가 알기 쉽게 해주기 -> 최후순위 (FsCalendar로 변경 고민중)
   
## 9/17
   - extension + 재사용 코드 모듈화
   - setting 테이블 뷰 생성
   - 문의하기, 버전, 오픈소스 뷰 
   - 백업, 복구 구현 완료 -> 복구 후 어플에서 바로 refresh 시킬 수 없을까?
   
   - 남은것
      - 전채뷰애서 cell을 삭제하면 오류 발생(realm 관련)
      - 다국어 지원
      - 레이아웃 토대에 맞게 UI개선
      - 일기를 작성한 캘린더 날짜에 이벤트를 표시해서 유저가 알기 쉽게 해주기 -> 최후순위 (FsCalendar로 변경 고민중)
      
## 9/17
   - 남은것
      - 전채뷰애서 cell을 삭제하면 오류 발생(realm 관련)
      - 다국어 지원
      - 레이아웃 토대에 맞게 UI개선
      - 일기를 작성한 캘린더 날짜에 이벤트를 표시해서 유저가 알기 쉽게 해주기 -> 최후순위 (FsCalendar로 변경 고민중)

## 9/18 ~ 21

   - 전반적인 UI 개선완료
   - extension 사용하여 러프한 string 값들 제거
   - 커스텀 폰트 적용 완료

   - 남은것
      - 전채뷰애서 cell을 삭제하면 오류 발생(realm 관련)
      - 다국어 지원
      - 일기를 작성한 캘린더 날짜에 이벤트를 표시해서 유저가 알기 쉽게 해주기 -> 최후순위 (FsCalendar로 변경 고민중) -> 
      
## 9/22
   - 다국어(일본어, 중국어(간체), 영어, 한국어) 지원 완료
   - fscalendar 쓰지 않기로 결정

   - 남은것
      - 앱 이름, 설명 다국어지원
