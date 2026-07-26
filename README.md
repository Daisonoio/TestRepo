# TestRepo — a sample project for trying ReviewCheck

This repository exists for **one purpose**: to give you a small, self-contained C# project and a
one-command way to generate a realistic code change, so you can **try the [ReviewCheck](https://github.com/Daisonoio/ReviewCheck)
guided review flow** without needing a real change of your own.

It is a **fixture / sandbox**, not a real application. The code is deliberately tiny and easy to
understand — the point is the *review experience*, not the program.

## What's in it

A minimal console app — a calculator:

- `src/TestProject/Program.cs` — entry point
- `src/TestProject/Calculator.cs` — the `ICalculator` interface
- `src/TestProject/SimpleCalculator.cs` — the implementation
- `src/TestProject/Config.cs` — app configuration
- `scripts/make-change.*` — the change generator (see below)

## Prerequisites

- The [.NET 8 SDK](https://dotnet.microsoft.com/download) and `git`.
- **ReviewCheck installed in Claude Code** — the MCP server registered and the `/reviewcheck.agent`
  command available. If you haven't done that yet, follow
  [ReviewCheck → Getting started](https://github.com/Daisonoio/ReviewCheck#getting-started) first
  (it's a one-time, global setup).

## Try the flow in three steps

### 1. Clone

```bash
git clone https://github.com/Daisonoio/TestRepo.git
cd TestRepo
```

### 2. Generate a change to review

Run the change generator. It stages a small **"discount pricing"** feature that spans several files
with real cross-file links — exactly the shape ReviewCheck is designed to walk you through:

```bash
# macOS / Linux
./scripts/make-change.sh

# Windows (PowerShell)
./scripts/make-change.ps1
```

This produces an uncommitted diff:

| File | Change | Why it's interesting |
|---|---|---|
| `PricingRules.cs` | **new** — `MaxDiscountPercent` constant + `Clamp()` | the value other blocks build on |
| `DiscountCalculator.cs` | **new** — `ApplyDiscount()` | **uses** `PricingRules.Clamp` (a cross-file link) |
| `Program.cs` | **edited** — a short discount demo | **uses** `DiscountCalculator` (the seam to check) |

Confirm it with `git status` — you should see two new files and a modified `Program.cs`.

### 3. Review it with ReviewCheck

Open **Claude Code in this folder** and run:

```
/reviewcheck.agent
```

(or just ask *"review my changes with ReviewCheck"*). It reads the local `git diff`, splits it into
ordered blocks, and guides you one block at a time — **accept** or **request a correction** for each —
showing the code next to its explanation, the links between blocks, and the **seam** where a cross-block
bug would hide (does everything that calls `ApplyDiscount` / `Clamp` handle the capped value?).

At the top you'll see a coloured **analysis-mode disclaimer**: 🟡 if you configured an LLM key (grounded
explanations), or 🔴 if you didn't (your host model interprets the code). Both are expected — see
[ReviewCheck → Analysis modes](https://github.com/Daisonoio/ReviewCheck#analysis-modes).

## Start over

To reset to a clean slate and run the test again:

```bash
./scripts/make-change.sh --reset      # macOS / Linux
./scripts/make-change.ps1 -Reset      # Windows (PowerShell)
```

This deletes the two generated files and restores `Program.cs`, so `git status` is clean again.

## Building / running the app (optional)

The app itself still builds and runs, if you want to see it work:

```bash
dotnet run --project src/TestProject/TestProject.csproj
```

---

<sub>Want to review your **own** changes instead? You don't need this repo — install ReviewCheck and run
`/reviewcheck.agent` in any C# repository with uncommitted changes.</sub>
