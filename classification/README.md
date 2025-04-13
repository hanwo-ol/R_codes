**교수님 초기 요구(04 11)**
```
데이터 및 분류기 구축 (2종) / 훈련과 평가 구분 (2장)
각각의 예측 결과에 대해서 두 개의 1) 혼동행렬을 구함 이로부터 2) 정밀도 3) 재현율 4) 예측정확도 계산 (3장)
```
초기 파일 -> `classifier.r`

**교수님 추가 요구 사항(04 13 피드백)**
```
데이터과학입문에서 의사결정 나무는 다루지 않습니다.  의사결정나무 대신에 로지스틱 회귀분석으로 바꾸어 주시기 바랍니다.
그리고 K-최근접에서 K의 설정값을 알려주어야 합니다. 로지스틱 회귀분석 설명이 어렵다면 K=1, K=10 이렇게 해도 됩니다.
```
반영 -> `classifier_v2.r`

optional learning 추가: k 고르는 과정이 필요하다? -> `learn_more_k.r`


#### 사용 데이터 셋   
penguins dataset   
``` r
  Horst AM, Hill AP, Gorman KB (2020). palmerpenguins: Palmer Archipelago (Antarctica) penguin
  data. R package version 0.1.0. https://allisonhorst.github.io/palmerpenguins/. doi:
  10.5281/zenodo.3960218.

LaTeX 사용자들을 위한 BibTeX 항목은 다음과 같습니다

  @Manual{,
    title = {palmerpenguins: Palmer Archipelago (Antarctica) penguin data},
    author = {Allison Marie Horst and Alison Presmanes Hill and Kristen B Gorman},
    year = {2020},
    note = {R package version 0.1.0},
    doi = {10.5281/zenodo.3960218},
    url = {https://allisonhorst.github.io/palmerpenguins/},
  }
```
