보충 설명용 페이지
---

```html
        <div id="content-area" class="main">
            <h1 class="title news-title">오늘의 주요 뉴스</h1>
            <p>첫 번째 뉴스 문단입니다. <a href="/news/1" class="internal-link">자세히 보기</a></p>
            <div class="article-body">
                <p class="summary">이것은 요약 문단입니다.</p>
                <p>두 번째 뉴스 문단입니다. <a href="external-site.com" target="_blank">외부 링크</a></p>
                <img src="image.png" alt="뉴스 이미지">
            </div>
            <ul>
                <li>항목 1</li>
                <li class="special">항목 2 (특별)</li>
                <li>항목 3</li>
            </ul>
        </div>
```


*   **주요 CSS 선택자 유형 및 BeautifulSoup 예시 (위 HTML 기준):**

    | 선택자 유형        | 예시 CSS 선택자                | 설명                                                                 | BeautifulSoup 사용 (`soup.select(...)`)                                       |
    | :----------------- | :----------------------------- | :------------------------------------------------------------------- | :---------------------------------------------------------------------------- |
    | **1. 기본 선택자** |                                |                                                                      |                                                                               |
    | 태그               | `p`                            | 모든 `<p>` 태그 선택                                                   | `soup.select('p')` (3개의 `<p>` 태그 리스트)                                  |
    | 클래스             | `.title`                       | `class` 속성값이 "title"인 모든 요소 선택                               | `soup.select('.title')` (`<h1>` 태그 리스트)                                  |
    |                    | `.news-title`                  | (여러 클래스 중 하나)                                                      | `soup.select('.news-title')` (`<h1>` 태그 리스트)                             |
    | ID                 | `#content-area`                | `id` 속성값이 "content-area"인 요소 선택 (ID는 페이지 내 고유)           | `soup.select('#content-area')` (`<div>` 태그 리스트, 요소 1개)                |
    | **2. 속성 선택자** |                                |                                                                      |                                                                               |
    | 특정 속성 존재     | `[alt]`                        | `alt` 속성을 가진 모든 요소                                              | `soup.select('[alt]')` (`<img>` 태그 리스트)                                  |
    | 특정 속성값 일치   | `a[target="_blank"]`           | `target` 속성값이 "_blank"인 `<a>` 태그                                  | `soup.select('a[target="_blank"]')` (외부 링크 `<a>` 태그 리스트)              |
    |                    | `[class="summary"]`            | `class` 속성값이 정확히 "summary"인 요소                               | `soup.select('[class="summary"]')` (요약 `<p>` 태그 리스트)                   |
    | 속성값 일부 포함   | `a[href*="news"]`              | `href` 속성값에 "news" 문자열을 포함하는 `<a>` 태그                        | `soup.select('a[href*="news"]')` (내부 링크 `<a>` 태그 리스트)                  |
    | 속성값 시작        | `a[href^="/"]`                 | `href` 속성값이 "/"로 시작하는 `<a>` 태그 (상대 경로 내부 링크)             | `soup.select('a[href^="/"]')` (내부 링크 `<a>` 태그 리스트)                  |
    | 속성값 끝          | `img[src$=".png"]`              | `src` 속성값이 ".png"로 끝나는 `<img>` 태그                              | `soup.select('img[src$=".png"]')` (`<img>` 태그 리스트)                       |
    | **3. 계층 선택자** |                                |                                                                      |                                                                               |
    | 자손 (Descendant)  | `div p`                        | `<div>` 태그의 모든 자손 `<p>` 태그 (하위의 하위도 포함)                   | `soup.select('div p')` (3개의 `<p>` 태그 리스트)                              |
    |                    | `#content-area a`              | ID가 "content-area"인 요소의 모든 자손 `<a>` 태그                      | `soup.select('#content-area a')` (2개의 `<a>` 태그 리스트)                      |
    | 자식 (Child)       | `div > p`                      | `<div>` 태그의 직계 자식 `<p>` 태그                                      | `soup.select('div > p')` (ID가 content-area인 div의 직계 자식 p는 없음. article-body div의 직계 자식 p는 2개) |
    |                    | `.article-body > p`            | 클래스가 "article-body"인 요소의 직계 자식 `<p>` 태그                    | `soup.select('.article-body > p')` (2개의 `<p>` 태그 리스트)                  |
    | **4. 복합 선택자** |                                |                                                                      |                                                                               |
    | 여러 조건 (AND)    | `p.summary`                    | `<p>` 태그이면서 `class`가 "summary"인 요소                              | `soup.select('p.summary')` (요약 `<p>` 태그 리스트)                           |
    |                    | `div#content-area .title`      | `id`가 "content-area"인 `<div>`의 자손 중 `class`가 "title"인 요소       | `soup.select('div#content-area .title')` (`<h1>` 태그 리스트)                 |
    | 여러 선택자 (OR)   | `h1, .summary`                 | `<h1>` 태그 또는 `class`가 "summary"인 요소                             | `soup.select('h1, .summary')` (`<h1>`과 요약 `<p>` 태그 리스트)             |
    | **5. 가상 클래스 (일부)** |                       |                                                                      |                                                                               |
    | n번째 자식         | `ul li:nth-child(2)`           | `<ul>`의 두 번째 `<li>` 자식                                             | `soup.select('ul li:nth-child(2)')` (두 번째 `<li>` 태그 리스트)             |
    | 특정 클래스를 가진 n번째 자식 | `ul li.special:nth-child(2)` | `<ul>`의 두 번째 `<li>` 자식이면서 `class`가 "special"인 요소        | `soup.select('ul li.special:nth-child(2)')` (두 번째 `<li>` 태그 리스트) |

*   **`find()`/`find_all()` vs `select()`**
    *   `find("태그명", attrs={"속성명": "값"})`는 `select('태그명[속성명="값"]')`과 유사하게 동작합니다.
    *   간단한 선택은 `find()`/`find_all()`이 직관적일 수 있습니다.
    *   복잡한 계층 구조, 여러 조건 조합, CSS 문법에 익숙하다면 `select()`가 더 강력하고 간결한 코드를 제공할 수 있습니다.
    *   **제공된 Guardian 코드의 `soup.find("div", attrs={"data-gu-name": "body"})`는 `soup.select_one('div[data-gu-name="body"]')` (또는 `soup.select('div[data-gu-name="body"]')[0]`) 와 동일한 결과를 냅니다.** (`select_one`은 첫 번째 일치 요소만 반환)
