// 사진은 확인한 요리와 단계에만 연결한다. 다른 레시피는 서버 원문을 표시한다.
const tofuPhotos = new Map([
  ['두부 물기 빼고 썰기', ['tofu-cut.jpg','두께를 맞춰 썬 두부']],
  ['두부의 물기를 빼고 도톰하게 썰어요.', ['tofu-cut.jpg','두께를 맞춰 썬 두부']],
  ['아랫면이 노릇해지면 뒤집기', ['tofu-golden.jpg','양면을 노릇하게 부친 두부']],
  ['팬에서 앞뒤로 노릇하게 부쳐요.', ['tofu-golden.jpg','양면을 노릇하게 부친 두부']],
])

export function RecipeSteps({ name, steps = [] }) {
  if (!steps.length) return <p className="text-sm">등록된 조리 순서가 없어요.</p>
  const rows = steps.map(step => {
    const [title, description] = Array.isArray(step) ? step : [step]
    const photo = name === '두부 달걀 부침' ? tofuPhotos.get(title) : null
    return { title, description, photo }
  })
  return <><ol className="mf-steps">{rows.map(({ title, description, photo }, index) => <li key={index}>
    <div><h4><span className="mr-2">{index + 1}</span>{title}</h4>{description && <p>{description}</p>}</div>
    {photo && <img src={'/wireframe/' + photo[0]} alt={photo[1]} />}
  </li>)}</ol>
  {rows.some(row => row.photo) && <details className="mf-options text-xs"><summary>사진 출처</summary>
    <p>화면 비율에 맞게 자른 사진입니다. <a href="https://commons.wikimedia.org/wiki/File:Tofu_slices.png" target="_blank" rel="noreferrer">Tiia Monto · Tofu slices</a> (<a href="https://creativecommons.org/licenses/by-sa/4.0/">CC BY-SA 4.0</a>), <a href="https://commons.wikimedia.org/wiki/File:Korean_cuisine-Dubu_buchim-01.jpg" target="_blank" rel="noreferrer">정희 강 · Dubu buchim</a> (<a href="https://creativecommons.org/licenses/by/2.0/">CC BY 2.0</a>).</p>
  </details>}</>
}
