#import "@preview/quill-assignment:0.1.0": *

= Embodied Scaling Laws

Here is normal content.

#lorem(500)

Answer or notes here. This is an inline formular $E=m c^2$. In Typst, the only warpper for formulas is the *signle* dollar sign.

#question(title: "Multi-Layer Perceptron")[
  Derive the parameter update rule for the weight matrix using the chain rule.
]

Answer or notes here.

#answer[
  The gradient with respect to the weight matrix is

  $
  (partial L)/(partial W^((l))) = delta^((l)) (a^((l-1)))^T
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
