# flex-module-sample
---

이 프로젝트는 flex team의 헥사고날 모듈 프로젝트를 기반으로 CDS 성능 테스트를 해보는 벤치마크 프로젝트입니다.

구조적인 표현을 위해 필요한 최소한의 코드만 포함하고 있습니다.


## 실행 안내

1. [sdkman 설치](https://sdkman.io/install/)를 권장합니다.
2. 실행에는 docker 환경이 필요합니다. gradle check 태스크는 integrationTest를 포함하고 있으며, integrationTest는 testcontainers를 이용하고 있습니다.
   1. [mac](https://docs.docker.com/desktop/setup/install/mac-install/)
   2. [windows](https://docs.docker.com/desktop/setup/install/windows-install/)
   3. [linux(ubuntu)](https://docs.docker.com/desktop/setup/install/linux/ubuntu/)
3. IDE는 JetBrains의 [IntelliJ Community 버전](https://www.jetbrains.com/help/idea/installation-guide.html)을 권장합니다. Ultimate도 무방합니다.
4. `./gradlew check` 를 통해 검증이 가능합니다.
5. `./gradlew bootRun` 을 실행하시면 8080 port를 이용해 서버가 기동됩니다. 
6. [swagger-ui](http://localhost:8080/swagger-ui.html) 를 통해 api 호출을 확인해보실 수 있습니다.  
