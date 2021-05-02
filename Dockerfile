# 1. 우분투 설치
FROM ubuntu:18.04

# 2. 메타데이터 표시
LABEL "purpose"="practice"

# 3. 업데이트 및 아파치 설치
RUN apt-get update
RUN apt-get install apache2 -y

# 4. 호스트에 있는 파일을 추가
ADD web.html /var/www/html

# 5. 작업공간 이동(=cd)
WORKDIR /var/www/html

# 6. 거기서 test2.html 파일생성
RUN ["/bin/bash", "-c", "echo hello > test2.html"]

# 7. 포트 80번 노출 지정
EXPOSE 80

# 8. 컨테이너 생성시 시작명령어
CMD apachectl -DFOREGROUND