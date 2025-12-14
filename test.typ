#import "@preview/physica:0.9.2": *
#import "@preview/equate:0.3.2" : *

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
      &eq.dots.down #calc.round(numbers_avg, digits: 1)
  $

+ 分散及び標準偏差を求めよ。



