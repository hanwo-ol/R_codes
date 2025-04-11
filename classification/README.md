**교수님 초기 요구(04 11)**
```
데이터 및 분류기 구축 (2종) / 훈련과 평가 구분 (2장)
각각의 예측 결과에 대해서 두 개의 1) 혼동행렬을 구함 이로부터 2) 정밀도 3) 재현율 4) 예측정확도 계산 (3장)
```

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


#### 데이터 셋 간략 설명   

데이터    
* 총 3종류의 펭귄(Adelie, Chinstrap, Gentoo)에 대한 관측 데이터가 포함되어 있음.
* 각 펭귄 개체에 대해 다음과 같은 정보(변수)를 담고 있음
  *   `species`: 펭귄의 종 (범주형 - 목표 변수로 사용함)
  *   `island`: 펭귄이 관측된 섬 이름 (범주형)
  *   `bill_length_mm`: 부리의 길이 (수치형, mm 단위)
  *   `bill_depth_mm`: 부리의 두께(높이) (수치형, mm 단위)
  *   `flipper_length_mm`: 날개(지느러미)의 길이 (수치형, mm 단위)
  *   `body_mass_g`: 체중 (수치형, g 단위)
  *   `sex`: 펭귄의 성별 (범주형)
  *   `year`: 관측 연도 (수치형 또는 범주형으로 사용 가능)
