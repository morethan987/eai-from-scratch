#import "@preview/quill-assignment:0.1.0": *

#show: assignment.with(
  title: "Embodied Artificial Intelligence\nfrom Scratch",
  subtitle: "Foundations, Architectures, Scaling, and Systems for Generalist Robot Policies",
  course: "EAI from Scratch",
  assignment: "Assignment",
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
#include "chapters/robotic_control_and_simulation.typ"

#pagebreak()
#include "chapters/model_arch.typ"

#pagebreak()
#include "chapters/offline_learning.typ"

#pagebreak()
#include "chapters/data_engineering.typ"

#pagebreak()
#include "chapters/scaling_law.typ"

#pagebreak()
#include "chapters/systems.typ"

#pagebreak()
#include "chapters/online_learning.typ"

#pagebreak()
#bibliography("refs.bib", title: "References", style: "ieee")
