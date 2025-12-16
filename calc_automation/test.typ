#import "@preview/physica:0.9.2": *
#import "@preview/equate:0.3.2" : *
#import "@preview/lilaq:0.5.0" as lq

#show figure.where(
  kind: table
): set figure.caption(position: top)
#set text(
  font: (
    "Yu Mincho",
    "BIZ UDMincho"
  ),
  size: 13pt
)

= Scripting
Typst には、条件文、ループ、関数、メソッドなどの強力な埋め込みスクリプト機能があります。

#let count = 8
#let nums = range(1, count + 1)
#let fib(n) = (
  if n <= 2 { 1 }
  else { fib(n - 1) + fib(n - 2) }
)

#figure(
  table(
    columns: count,
    ..nums.map(n => $F_#n$),
    ..nums.map(n => str(fib(n))),
  )
)


#show: equate.with(breakable: true, sub-numbering: false, number-mode: "label")
#set math.equation(numbering: numbering.with("(1.1)"), supplement: "Eq.")
#show math.equation: set text(font:("New Computer Modern Math", "MS Mincho"))
#set enum(numbering: "(1)")

#let Join(arr, join) = {
  for i in range(arr.len()){
    if i != (arr.len() - 1){
      [#arr.at(i)#join #sym.space.med]
    }
    else{
      [#arr.at(i)]
    }
  }
}

#set heading(numbering: "1.")
#show heading.where(level: 1): it => {
  [#text(size: 12pt, weight: "regular")[#it.numbering #it.body]]
}

#pagebreak()

#set page(
  header: [令和7年度 第1回レポート課題],
)

= 水槽の水温を25.0℃に設定し、7日間にわたって水温[℃]を温度計で測定したところ、次のようになった。

#let numbers = (24.1, 25.2, 26.5, 25.3, 24.2, 24.8, 25.6)
$
  #Join(numbers, [,])
$

+ 平均を求めよ。

  #let numbers_avg = numbers.sum() / numbers.len()

  測定結果を$x$、測定結果の標本平均を$macron(x)$とすると、
  $
    macron(x) &= 1 / numbers.len() sum_i x_i \
      &eq.dots.down #calc.round(numbers_avg, digits: 1) thick [℃]
  $

  #let CalculateVariance(arr) = {
    let total_diff_square = 0
    for i in arr{
      let diff = i - numbers_avg
      total_diff_square += diff * diff
    }
    return total_diff_square / arr.len()
  }

+ 分散及び標準偏差を求めよ。

  #let numbers_var = CalculateVariance(numbers)
  標本分散を$s^2$、標準偏差を$s$とすると、標本分散は
  $
    s^2 &= 1 / numbers.len() sum_i (x_i - macron(x))^2 \
    &= #calc.round(numbers_var, digits: 2) thick [℃]
  $

  標準偏差は
  $
    s = sqrt(s^2) eq.dots.down #calc.round(calc.sqrt(numbers_var), digits: 2) thick [℃]
  $

#pagebreak()

#set page(
  header: [データ操作]
)

#let data = csv("./data.csv")
#let header = data.remove(0)

#header.insert(0, [番号])
#header.push([売上])
#header.push([累計売上])

#{
  data = data.enumerate(start: 1).map(c => c.flatten())

  let total_price = 0
  for i in range(data.len()){
    let price = int(data.at(i).at(-1))
    let quantity = int(data.at(i).at(-2))
    total_price += price * quantity
    data.at(i).push(price * quantity)
    data.at(i).push(total_price)
  }
}

#figure(
  table(
    columns: header.len(),
    inset: 7pt,
    table.header(..header),
    ..data.flatten().map(c => str(c))
  )
)

#let day_sales = data.map(r => (r.at(1), r.at(-2)))
#let day_total_sales = day_sales.fold(
    (:),
    (acc, x) => {
      let day = x.at(0)
      acc.insert(day, acc.at(day, default:0) + x.at(1))
      return acc
    }
  )

#day_total_sales.keys()
#day_total_sales.values()
