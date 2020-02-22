# hanster_app
## 최종 정리사항은 zip파일을 참고하세요.

## **10/12**
+ root.dart, login.dart, checkID.dart, front.dart 추가.
+ qna.dart 임시 이식완료.
  구글로그인 -> qna페이지 firebase 데이터 연동까지. (아직 디자인은 프레임만,)
<img width="313" alt="스크린샷 2019-10-31 오후 9 15 30" src="https://user-images.githubusercontent.com/47979730/67945978-9aa3ed00-fc23-11e9-919d-91cda3ba2b04.png">


+ pubspec.yaml에 modal_progress_hud Package추가. (돌아가는 로딩 표시)
+ 통째로 안받고 라이브러리만 받을거면 json파일 교체하고 pubspec에 패키지 하나 추가해야함 !



# Notice

## **10/12**
- modal_progress_hud Package 
Future - async 처럼 대기가필요한 동작에서 로딩바를 표시해줌. 

추가한 이유 : 로그인하거나 데이터 불러올때 아무런 표시가 안돼서 찝찝해서.. 근데 많이 쓸일은 없을듯.

사용법 : pubspec.yaml에 package추가하고(깃헙파일참조)
원하는 페이지에 bool값을 하나 만든다. ex) bool loading = false;
body를 wrap new widget 해서 ModalProgressHUD로 감싼다.

원하는 동작 안에 setState로 true로 바꿔준다(로딩바 표시)

<img width="206" alt="스크린샷 2019-10-12 오전 3 27 27" src="https://user-images.githubusercontent.com/47979730/66675805-0d631d80-eca1-11e9-8470-991965b7f055.png">


ModalProgressHUD 괄호 끝나기 전에 inAsyncCall: loading(bool 변수명), ); 으로 추가해준다.

Future - async 함수 제일 마지막에 setState로 다시 loading = false; 로 바꿔준다. (로딩완료)
(이미지 예시):

<img width="200" alt="스크린샷 2019-10-12 오전 3 34 24" src="https://user-images.githubusercontent.com/47979730/66675883-3c798f00-eca1-11e9-9274-3a5e0acf6398.png">
.
