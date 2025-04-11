**교수님 초기 요구(04 11)**
```
데이터 및 분류기 구축 (2종) / 훈련과 평가 구분 (2장)
각각의 예측 결과에 대해서 두 개의 1) 혼동행렬을 구함 이로부터 2) 정밀도 3) 재현율 4) 예측정확도 계산 (3장)
```

### 코드 설명   
이 실습은 Palmer Penguins 데이터셋을 사용해 두 가지 기본적인 머신러닝 분류 알고리즘인 의사결정 트리(Decision Tree)와 k-최근접 이웃(k-Nearest Neighbors, k-NN)을 구현하고 평가하는 과정을 보여줍니다.

#### 과정    
1. 데이터 준비: 펭귄 데이터셋을 불러와 분석에 적합하도록 준비합니다. (결측치 제거, 변수 선택, 훈련/테스트 데이터 분할)

2. 모델 생성:
  - 의사결정 트리: 펭귄의 신체 측정치(부리 길이/깊이, 팔 길이, 몸무게 - 4개 변수)를 기반으로 펭귄의 종류(species)를 분류하는 모델을 만듭니다.
  - k-NN: 의사결정 트리에서 사용한 4개 변수에 관측 연도(year)를 추가하여 총 5개의 변수를 사용하여 펭귄의 종류를 분류하는 모델을 만듭니다. (k=5 사용)

3. 모델을 이용해 분류(classification): 생성된 각 모델을 사용하여 테스트 데이터셋의 펭귄 종류를 분류합니다.

4. 모델 평가: 각 모델의 분류 성능을 평가하기 위해 다음 지표를 계산합니다.
  - 혼동 행렬 (Confusion Matrix): 모델이 각 클래스를 얼마나 잘 분류했는지 보여주는 행렬
  - 정확도 (Accuracy): 전체 분류 결과 중 올바르게 분류한 비율
  - 정밀도 (Precision): 모델이 특정 클래스로 분류한 것 중 실제 해당 클래스인 비율
  - 재현율 (Recall): 실제 특정 클래스인 것 중 모델이 해당 클래스로 올바르게 분류한 비율




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
