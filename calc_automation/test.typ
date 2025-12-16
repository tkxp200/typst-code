#import "@preview/physica:0.9.2": *
#import "@preview/equate:0.3.2" : *
#import "@preview/cetz:0.4.2" : util.matrix
#import "@preview/numty:0.1.0" as nt
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

#let A = ((0,1), (1,1))
#let A_2 = matrix.mul-mat(A,A)
#let A_3 = matrix.mul-mat(A_2, A)
#let A_4 = matrix.mul-mat(A_3, A)


$
  A^1 &= #nt.p(A) \
  A^2 &= #nt.p(A)^2 &= #nt.p(A_2) \
  A^3 &= #nt.p(A)^3 &= #nt.p(A_3) \
  A^4 &= #nt.p(A)^4 &= #nt.p(A_4)
$

#let lambda_1 = (1 + calc.sqrt(5)) / 2
#let lambda_2 = (1 - calc.sqrt(5)) / 2

$
  lambda_1 = #lambda_1\
  lambda_2 = #lambda_2
$

#let P = ((2, 2), (1 + calc.sqrt(5), 1 - calc.sqrt(5)))
#let P_inv = matrix.inverse(P)
#let D = ((lambda_1, 0), (0, lambda_2))
#let PowerOfMatrixD(n) = {
  return ((calc.pow(lambda_1, n), 0), (0, calc.pow(lambda_2, n)))
}

#let CalculatePowerOfMatrixA(n) = {
  let dp_inv = matrix.mul-mat(PowerOfMatrixD(n), P_inv)
  return matrix.mul-mat(P, dp_inv)
}

#let CalculateFibonacci(n) = {
  let A_pow_n = CalculatePowerOfMatrixA(n)
  return calc.round(A_pow_n.at(0).at(1))
}

#let indexes = range(1, 11)

#figure(
  table(
    inset: 8pt,
    columns: indexes.len() + 1,
    table.header([$n$], ..indexes.map(i => str(i))),
    [$F_n$], ..indexes.map(i => str(CalculateFibonacci(i))),
    [$F_(n+1) \/ F_n$ ],
    ..indexes.map(i => str(calc.round(CalculateFibonacci(i+1)/ CalculateFibonacci(i), digits: 3)))

  )
)

#figure(
  lq.diagram(
    legend: (position: top, inset: 0.1em),
    lq.yaxis(
      position: right,
      label: [$F_(n+1) \/ F_n$],
      lq.plot(
        range(1,11),
        x => CalculateFibonacci(x+1)/ CalculateFibonacci(x),
        label: text(size: 10pt)[$F_(n+1) \/ F_n$]
      )
    ),
    xlabel: [$n$],
    ylabel: [$F_n$],
    lq.plot(
      range(1,11),
      x => CalculateFibonacci(x),
        label: text(size: 10pt)[$F_n$]
    ),
  )
)

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


#figure(
  lq.diagram(
    title: [日付別売上総額],
    width: 9cm,
    height: 6cm,
    xaxis: (
      ticks: day_total_sales.keys().enumerate(),
      label: [日付],
    ),
    yaxis: (
      exponent: none,
      lim: (5000, 6500),
      label: [売上総額[円]],
    ),
    lq.bar(
      range(day_total_sales.keys().len()),
      day_total_sales.values(),
      width: 0.5
    )
  )
)