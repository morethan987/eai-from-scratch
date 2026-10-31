#import "@preview/quill-assignment:0.1.0": *

#show: assignment.with(
  title: "Vison Language Action Model\nfrom scratch",
  subtitle: "Theoretical Analysis and Empirical Benchmarking",
  course: "VLA tutorial for beginners",
  assignment: "Assignment 1",
  student: "Morethan",
  student-id: "2026-123456",
  instructor: "Dr. Mystery",
  department: "Department of Bed No.1",
  university: "Dormitory University",
  date: datetime.today(),
  theme: "nord-light",
  cover-page: true,
  cover-style: "geometric",
  toc: true,
  font: "Libertinus Serif",
  code-font: "DejaVu Sans Mono",
  margin: (x: 40pt, top: 50pt, bottom: 50pt)
)

#pagebreak()

= Problem 1

#question(title: "Multi-Layer Perceptron")[
  Derive the parameter update rule for the weight matrix using the chain rule.
]

#answer[
  The gradient with respect to the weight matrix is

  $
  (partial L)/(partial W^((l)))
  =
  delta^((l))
  (a^((l-1)))^T
  $

  #note(type: "tip")[
    Use log-sum-exp stabilization to avoid numerical overflow.
  ]

    Self-attention computes a weighted representation of every token by
  comparing queries and keys. #cite(<vaswani2017attention>, form: "prose")
  argue that removing recurrence lets every position be processed in
  parallel, which is the core efficiency gain of the Transformer. The
  residual connections that keep deep
  stacks trainable were established earlier in computer vision @he2016resnet,
  and the attention layer plays the same gradient-stabilizing role here.

    Self-attention computes a weighted representation of every token by comparing
  queries and keys, entirely in parallel across positions. Because no recurrent
  state is carried through time, training parallelizes over the sequence length,
  which is the core efficiency argument made by the Transformer paper
  @vaswani2017attention. The residual connections that keep deep stacks
  trainable were established earlier in computer vision @he2016resnet, and the
  attention layer plays the same gradient-stabilizing role here.

  A thorough treatment of the surrounding building blocks (embeddings,
  layer normalization, optimization) can be found in @goodfellow2016dl.
]

= References

#bibliography("refs.bib", title: none, style: "ieee")
