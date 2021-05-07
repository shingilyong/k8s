**prometheus를 통해서 kubernetes 클러스터를 모니터링 하는 방법과 grana로 대쉬보드 생성하는 방법에 대해 알아보자.**

---

# 1\. Prometheus 란?

**Prometheus는 현재 kubernetes 모니터링에 가장 많이 사용되고 있는 오픈 소스 기반 모니터링 시스템이다.**

**CNCF에 소속되어 있으며, k8s 클러스터 및 컨테이너들을 손쉽게 모니터링 할 수 있다.**

## **1\. Prometheus 특징**

-   **promQL 쿼리 언어를 사용한다.**
-   **Grafana 같은 대쉬보드 시스템을 이용하여 대쉬보드로 측정 값을 모니터링 할 수 있다.**
-   **메트릭 이름과 key-value 형태로 식별되는 시계열 데이터를 제공한다.**
-   **경고(Alert)와 룰셋(Ruleset)을 만들 수 있다.**

## **2\. Prometheus 구조**

**모니터링을 하기 위해 메트릭을 수집하는 방식은 크게 Push 방식과 Pull 방식이 있다.**

**Push 방식은 각 서버나 애플리케이션에 클라이언트를 설치하고, 이 클라이언트가 데이터를 수집해서 메트릭 서버로 보내는 방식이다.**

**Pull 방식은 각 서버나 애플리케이션이 메트릭을 수집할 수 있는 엔드포인트를 제공한다. 그래서 메트릭 서버가 해당 엔드포인트를 호출하여 메트릭을 가지고 가는 방식이다.**

**Prometheus는 Pull 방식을 사용하며, 애플리케이션이 작동하면 메트릭 서버가 주기적으로 애플리케이션의 메트릭 엔드포인트에 접속하여 데이터를 가져오는 방식이다.**



-   **prometheus server : 시계열 데이터를 스크랩하고 저장한다.**

-   **Service discovery : prometheus는 메트릭을 pull 하기 때문에, 메트릭 수집 대상에 대한 정보가 필요하다. 메트릭 수집 대상은 파일 같은 것을 이용하여 직접 관리할  수도 있고,  k8s와 연동하여 자동으로 수집 대상을 동기화 할 수도 있다.**

-   **Pushgateway : "short-lived jobs"을 지우너하기 위해서 메트릭을 Push하기 위한 게이트웨이. 애플리케이션이 pushgateway에 메트릭을 push한 후, prometheus server가 pushgateway에 접근해 메트릭을 pull해서 가져온다.**

-   **Jobs/Expoerters : Exporter는 prometheus가 메트릭을 수집할 수 있도록, 특정 서버나 애플리케이션의 메트릭을 노출할 수 있게 도와주는 Agent이다.**

-   **Alertm****anager : 경고(Alert)를 관리한다. 메트릭에 대한 어떤 지표를 지정해놓고, 그 규칙을 위반하는 경고사항에 대해 slack이나 email로 경고를 전송하는 역할을 한다.**

-   **Data visualization : Data visualization은 다양한 모니터링 대시보드를 위한 시각화를 제공한다. prometheus 웹 UI에서도 간단한 그래프를 그릴 수 있지만, 일반적으로 Grafana같은 전문 시각화 도구를 이용하여 대시보드를 생성한다.**
