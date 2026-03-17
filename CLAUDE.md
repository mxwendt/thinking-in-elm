# CLAUDE.md — Thinking in Elm: Project Rules & Design Intelligence

This file is the authoritative guide for working on this codebase. Every
architectural decision, UI component, interaction pattern, and piece of prose
must trace back to one of the principles described here. Read this before
touching any file.

---

## What This Project Is

A redesigned version of Elm’s documentation, aiming to simplify learning the 
language and functional programming concepts in Elm through a clearer, more 
intuitive representation.

The current `guide.elm-lang.org` fails not because of bad writing but because
of bad representation: the medium is passive, abstraction only flows upward,
and syntax becomes a surrogate for understanding. This project fixes the
representation.

---

## The Four Principles (Non-Negotiable)

Every design decision must be justified by one or more of these four
principles. If it cannot be, it does not belong here.

### 1. Feynman's Chain — Unbroken Thread of Logic

The chapter order is a directed logical sequence. Each concept exists because
the previous one left a felt gap. The learner must feel, at every step:
*"Of course. It could not have been any other way."*

The chain:
1. A value exists.
2. Values can differ — they have **shape**. (Types)
3. The same shape can be transformed. (Functions)
4. Transformation can branch. (If / Pattern matching)
5. Values can be grouped. (Lists, Tuples, Records)
6. Groups can have distinct shapes. (Custom Types)
7. Shape-checking can be automated. (The compiler)
8. Transformation + State = Behavior. (The Elm Architecture)
9. Behavior + the world = Effects. (Commands & Subscriptions)

**Rule:** No concept may be introduced without a **felt need** established
first. Never introduce syntax before the learner has encountered the problem
that syntax solves. Dependencies are logical, not aesthetic.

Example: Custom Types appear in **Ch4, before TEA in Ch5**, because the Elm 
Architecture is built on the `Msg` type, and `Msg` is only intelligible once the 
learner understands custom types.

---

### 2. Bret Victor's Ladder — Fluid Movement Between Abstraction Levels

Understanding lives in the **transitions between levels**, not at any single
level. Every concept must simultaneously exist at three abstraction layers:

| Layer        | What it shows                                      | How it feels               |
|--------------|----------------------------------------------------|----------------------------|
| **Concrete** | A specific running value or program                | Edit it, poke it, break it |
| **Rule**     | The Elm code that produces this behavior           | Read it, modify it         |
| **Pattern**  | The type signature / abstract shape                | Hover to see what fits     |

Movement between layers must be **spatial and direct** — not navigational. The 
learner sees the connection; they do not infer it.

**Rule:** Every code block must have all three zoom levels. Switching between
them must be animated and preserve spatial alignment (the value `"Alice"` at
the Concrete level sits directly above the parameter `name` at the Rule level,
which sits above the type `String` at the Pattern level).

**Rule:** There is no one-way elevator to abstraction. Every abstract element
must provide an immediate, interactive path back to a concrete running example.

---

### 3. Playfair's Move — Recruit Latent Human Capabilities

William Playfair invented the bar chart by recruiting spatial/visual intuition
for economic data. Every major Elm concept must be grounded in a **physical
metaphor** that recruits an innate human capability. These metaphors are the
**primary representation**. The Elm code is the secondary, precise
formalization.

| Elm Concept          | Latent Capability    | Physical Metaphor                                          |
|----------------------|----------------------|------------------------------------------------------------|
| Values               | Categorization       | Physical objects with distinct shapes and colors           |
| Types                | Shape-fitting        | Silhouettes — a value either fits or it doesn't            |
| Functions            | Flow / Cause-effect  | A machine with an input slot and an output slot            |
| Composition          | Flow                 | Pipes connecting machines (assembly line)                  |
| Pattern Matching     | Sorting / Routing    | A sorting machine that routes values by shape              |
| `Maybe`              | Containment          | A box that may be empty or hold something                  |
| `Result`             | Narrative            | A fork in the road — success path and failure path         |
| Lists                | Sequence             | A numbered conveyor belt                                   |
| Records              | Containment + Labels | A form or passport with named fields                       |
| The Elm Architecture | Cycle / Loop         | A clockwork mechanism: state → view → event → update → state |
| Commands             | Flow outward         | Arrows leaving the loop into the world                     |
| Subscriptions        | Flow inward          | Arrows entering the loop from the world                    |

**Rule:** Never introduce a concept as "a language feature." Introduce it as
the answer to a felt need, grounded in one of these physical metaphors first.
The metaphor appears before any syntax. The syntax is revealed as the text
encoding of something the learner already understands.

---

### 4. The Physical Intuition Imperative

Feynman's great insight (via Dyson): Einstein's productive period was driven by
physical images, not equations. When Einstein became a manipulator of
equations, he stopped creating. The same failure mode threatens Elm learners.

Without physical grounding, learners memorize `case x of` without the felt
sense of routing a value by its shape. They learn `Maybe` as a type annotation
without feeling "this computation might find nothing."

**Three hard rules — violations are architectural failures:**

1. **No code without output.** Every code block shows its live result. There
   is no "here is some code, try it in the online editor." The output is
   always visible alongside the code that produces it.

2. **No syntax before need.** Elm syntax is only shown after the learner has
   felt the problem it solves through interaction with a concrete example.

3. **No abstraction without a step down.** Every abstract rule, type
   signature, or architectural diagram provides an immediate interactive path
   back to a specific running example.

---

## Visual Design System

### Semantic Type Palette

Types have consistent visual identities throughout the **entire** guide. This
is load-bearing visual grammar — the learner's visual cortex builds an
unconscious association between color/shape and type.

| Type           | Color                              | Shape                          |
|----------------|------------------------------------|--------------------------------|
| `Int`          | Cobalt blue                        | Circle                         |
| `Float`        | Sky blue                           | Circle with dashed edge        |
| `String`       | Forest green                       | Rounded rectangle              |
| `Bool`         | Violet                             | Diamond                        |
| `List a`       | Amber                              | Repeating rail                 |
| `Maybe a`      | Orange halo around the inner type  | Outer shell, inner core        |
| `Result e a`   | Split: green left / red right      | A forking path                 |
| Custom type    | User-assigned from a palette       | Defined by its variants        |
| Functions      | Neutral gray                       | Machine with input/output slots|

**Rule:** These colors and shapes must not vary between chapters, examples, or
components. Consistency is the entire point. If a value is a `String`, it is
forest green and rounded everywhere, always.

It is allowed to change colors or shapes globally if another palette makes more
sense. Aim for an aesthetic of the visuals from https://visualizevalue.com/visuals
as well as the techiness of Nothing's design philosophy that is inspired by old
design classics (i.e. from Braun), https://playground.nothing.tech/.

---

### Small Multiples (Tufte)

Rather than showing one example of a concept sequentially, show the same
concept applied in **different contexts simultaneously**. The human visual
system detects the structural invariant across a grid far more efficiently than
reading paragraphs sequentially.

Example for pattern matching — four case expressions side-by-side:
- `TrafficLight` (Red | Yellow | Green)
- `Maybe Int` (Just n | Nothing)
- `Direction` (North | South | East | West)
- `Result e a` (Ok value | Err error)

The pattern — "list every possible shape, handle each one" — becomes visible as
structural similarity, not as a described rule.

**Rule:** Whenever the guide introduces a structural pattern (pattern matching,
function composition, `Cmd`/`Sub` pairing), reach for a small-multiples grid
before reaching for sequential explanation.

---

### Annotations On the Thing (Tufte)

Labels, explanations, and type annotations are placed **directly on the code
or diagram**, not in separate prose paragraphs the reader must cross-reference.

Example: a type signature is not explained below the code block. It is an
interactive overlay, spatially aligned with the code:

```
greet : String -> String
        ^^^^^^    ^^^^^^
           │         └──────────── output: "Hello Alice!"
           └────────────────────── input:  "Alice"
```

**Rule:** If an explanation can be placed spatially on the thing it explains,
it must be. Prose that merely describes a diagram that is sitting right there
is a representation failure.

---

## Interaction Design Rules

### The Consequence Chain (Ripple Effect)

When the learner changes a value or type, a visual ripple propagates to show
which downstream expressions are affected.

### Direct Value Manipulation (Victor's Scrubbing)

Values are directly manipulable, i.e.
- **Numbers**: drag left/right to scrub continuously
- **Strings**: click to edit in-place
- **Booleans**: click to toggle
- **Custom type variants**: click to cycle through all possible variants
- **List items**: drag to reorder; click to add or remove

Manipulating a value updates the surrounding code **bidirectionally** — the
code reflects the manipulated value. This makes the code feel like a
*description* of a thing, not a parallel universe.

### The Zoom Mechanism (Three Levels)

Every code block has three zoom levels with animated transitions that preserve
spatial correspondence:

| Zoom Level   | What is shown                                   |
|--------------|-------------------------------------------------|
| **Concrete** | A specific running example with specific values |
| **Rule**     | Elm code — values abstracted to parameter names |
| **Pattern**  | Type signature — the abstract shape of the rule |

## Chapter-by-Chapter Constraints

### Chapter 0 — The Terrain
Show the spatial map of the entire guide before any concept is introduced. A
directed graph of all concepts and their logical dependencies. The learner
must be able to see the whole journey before taking step one.

### Chapter 1 — Values
Start with `42`. Nothing else. Let the learner discover types through
interaction (change `42` to `"hello"` — the shape changes; try `42 + True` —
the shapes refuse to connect). The prose names what the learner has already
experienced.

Do NOT introduce yet: type annotations, functions, imports.

### Chapter 2 — Functions
Show the machine diagram **before** the Elm syntax. The syntax is the text
encoding of the diagram. Show them side-by-side, spatially aligned.

Do NOT introduce yet: recursion, higher-order functions, partial application.

### Chapter 3 — Structure
Introduce each grouping type at the exact moment the learner feels the need:
- **Lists** when they need "any number of the same thing"
- **Tuples** when a single-output function is not enough
- **Records** when tuple slots become hard to track

`List.foldl` is explicitly deferred to after Ch5 (TEA). Its felt motivation
arrives when the learner sees that running `update` over a list of messages is
the same pattern.

### Chapter 4 — Custom Types & Pattern Matching (THE HEART)
This is the conceptual center. It must not feel like "a type system feature."
It must feel like the answer to: *"I have a value that can be one of several
fundamentally different things."*

Start with a physical traffic light. Click through its states. Then reveal the
Elm encoding.

Pattern matching is introduced as a **sorting machine**, not as `case ... of`
syntax. The compiler's exhaustiveness check is the natural consequence of a
sorting machine with an unconnected exit — of course it refuses to run.

`Maybe` and `Result` are revealed as instances of custom types, not exceptions:
- `Maybe a` = `type Maybe a = Just a | Nothing` — a box, not magic
- `Result e a` = a fork in the road with data on both paths

### Chapter 5 — The Elm Architecture
The key insight to convey: TEA is a **mathematical inevitability** given pure
functions, not an architectural decision. Given that functions are pure, the
only place for change is in an explicit loop that passes old state in and new
state out. It could not have been any other way.

Build the counter incrementally:
1. Just the Model (a number)
2. Add the View (a render function, static)
3. Add the `Msg` type (named events, but nothing happens yet)
4. Add Update (the loop closes — watch it come alive)

The learner assembles it; they do not read a complete program.

### Chapter 6 — Commands & Subscriptions
The loop from Ch5 is extended with external arrows. The key insight: the loop
is **still closed**. All effects return as messages. `update` remains a pure
function. The runtime crosses the boundary; the learner's Elm code does not.

Use small multiples to show that HTTP, random numbers, and clock subscriptions
all follow the same structural pattern.

---

## Appendices

### Appendix A — The Reference Map
A complete directed graph of all concepts and dependencies. Interactive:
click any node to preview it and see its prerequisites. Filterable. This
makes the structure of the guide feel like a territory, not a list.

### Appendix B — The Type Universe
A periodic-table-style reference of `elm/core` types, organized by family
(numbers, text, collections, effects). Each entry shows:
- Type name and semantic visual shape (using the palette)
- Common values as concrete examples
- Operating functions, shown as machine diagrams

---

## The Overriding Principle (The Guard Rail)

> Keep the learner thinking in concrete physical images.

Any design decision that causes the learner to feel like they are
**manipulating symbols** rather than **understanding things** is wrong.

The documentation succeeds when the learner, six months later, explains Elm
to a colleague not by reciting type signatures but by **drawing a clockwork
loop on a whiteboard**, cutting it open to show the `Msg` flowing through
`update`, and saying: *"the whole thing is right there."*

That is the standard.

---

## How the Principles Divide Responsibility

| Principle                       | Governs                                   |
|---------------------------------|-------------------------------------------|
| **Feynman's chain**             | The *order* of chapters and concepts      |
| **Victor's ladder**             | The *form* of each chapter (3 zoom levels)|
| **Playfair's move**             | The *representation* (metaphor-first)     |
| **Tufte's principles**          | The *layout* (small multiples, on-thing annotations, density) |
| **Physical intuition imperative** | The *guard rail* — catches every violation |

The chain is vertical (concept → concept). The ladder is horizontal (concrete
→ abstract within a concept). Playfair provides the anchoring metaphor for
every rung. Tufte governs the visual density of every pane. The imperative
vetos anything that turns the learner into a symbol manipulator.

---

## Tech Stack Notes

- **Language:** Elm (compiled in the browser via elm-watch)
- **Entry point:** `src/Main.elm`
- **Dev command:** `npm run dev`
- **Serving:** open `index.html` directly or via `http-server .`
- The Elm compiler must run **in the browser** to power the inline editing
  and consequence-chain features. This is a hard architectural requirement —
  learner code must compile on every keystroke without leaving the page.
- **Styling**: Tailwind CSS

Do not use any external libraries or plugins if it can be solved by using
native W3C technologies like HTML5, Canvas, SVG etc.
