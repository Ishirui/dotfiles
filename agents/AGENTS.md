# Basic Guidelines
<!--- Based on: https://github.com/multica-ai/andrej-karpathy-skills/blob/main/CLAUDE.md ---> 

## 1. Think Before Coding

**Don't assume. Don't hide confusion. Surface tradeoffs.**

Before implementing:
- State your assumptions explicitly. If uncertain, ask.
- If multiple interpretations exist, present them - don't pick silently.
- If a simpler approach exists, say so. Push back when warranted.
- If something is unclear, stop. Name what's confusing. Ask.

## 2. Simplicity First

**Minimum code that solves the problem. Nothing speculative.**

- No features beyond what was asked.
- No abstractions for single-use code.
- No "flexibility" or "configurability" that wasn't requested.
- No error handling for impossible scenarios.
- If you write 200 lines and it could be 50, rewrite it.

Ask yourself: "Would a senior engineer say this is overcomplicated?" If yes, simplify.

## 3. Surgical Changes

**Touch only what you must. Clean up only your own mess.**

When editing existing code:
- Don't "improve" adjacent code, comments, or formatting.
- Don't refactor things that aren't broken.
- Match existing style, even if you'd do it differently.
- If you notice unrelated dead code, mention it - don't delete it.

When your changes create orphans:
- Remove imports/variables/functions that YOUR changes made unused.
- Don't remove pre-existing dead code unless asked.

The test: Every changed line should trace directly to the user's request.

## 4. Goal-Driven Execution

**Define success criteria. Loop until verified.**

Transform tasks into verifiable goals:
- "Add validation" → "Write tests for invalid inputs, then make them pass"
- "Fix the bug" → "Write a test that reproduces it, then make it pass"
- "Refactor X" → "Ensure tests pass before and after"

For multi-step tasks, state a brief plan:
```
1. [Step] → verify: [check]
2. [Step] → verify: [check]
3. [Step] → verify: [check]
```

Strong success criteria let you loop independently. Weak criteria ("make it work") require constant clarification.

# Conversational style
- During discussions, NEVER start implementing or modifying files without requesting permission from the user or waiting to be told so.
- Surround big autonomous work blocs (implementation, research etc.) with first, a summary of what you'll do, and at then end a summary of all edits/actions that have been taken

# Important behaviors to follow
## Be mindful of your commits, use git features
When implementing a new feature, always think about how this will get split into individual, easily-reviewable and _atomic_, *ordered* commits.
This makes it easier for the user to review the produced code, and guides the implementation naturally. *NEVER* write a big dump of changes in one go before preparing for a commit.

- Think about the breakdown of the work into atomic commits before starting the implementation
- Each commit should do one _thing_ and be able to, as much as possible, stand on its own.
- Implementation should start with foundational, infrastructure work, then build up into the main functionality, and finish with touch-ups, UX or code style improvements.
- Never mix bug fixes or refactors with features: a commit does at most _one_ of those three things 
- Don't be afraid to commit on your own, but follow semantic commit messages: `feat/fix/refactor/chore/docs/ci(scope): short description`

In general, use git features to simplify management of changes: stashes, interactive rebase, amending, worktrees etc.

## Use scripted tools, especially custom tooling
Always prefer using skills over relying on your own inference power.
If a codebase has specific tooling (e.g. invoke tasks, bazel targets, bash scripts) etc., always try to use them instead of 'standard' language tooling: they are there for a reason.

If a task is complex, many-stepped, requires a lot of token consumption or needs to be repeated multiple times, don't be afraid to write a script to do it instead of relying on your own inference power. Ask the user to review it beforehand.
Shell scripts should not be used for anything longer than ~30 lines or for complex loops: use Python if that is necessary.

## Ask questions, go deep, think about the caveats
Don't dive blindly into implementation, into getting the thing done. Oftentimes a task is vague, or the user is not sure of what they want or of the best way to do it.
These might be preemptively caught and discussed during planning: if you think of any of them, planning is the best time to adress them.
If they are encountered during implementation, do not be afraid to:
- Ask questions to the user, esp. for matters of preference
- Explore alternative solutions if the initial one proves too complex
- Think about the repercussions and tradeoffs of one approach vs the other

# Problem-solving approach and plan-writing etiquette
The preferred approach can be broken down into 6 phases:
1. *Explore* - Gain an understanding of the relevant pieces of the problem: the codebase we are implementing against, the possible solutions and approaches.
2. *Plan* - Think in detail about what you will do, informed by the previous step. This is the most crucial step, described in more detail below.
3. *Build* - Transform the plan into concrete code. If the plan was detailed enough, this should be an almost robotic step, delegated to a weaker agent.
4. *Validate* - Test the feature, verify it matches acceptance criteria of correctness and performance. These and the testing strategy should have been defined in step 2 ; if anything is wrong, go back to Plan or Build.
5. *Review* - Help the user judge the produced code quality. Clear the session, start fresh or with an entirely new model, and think of the code's style, maintainability, if it uses good patterns common in literature or across the codebase.
6. *Improve* - Tweak the built feature, improving it until the review is satisfying.
> The general idea is to fully define a task before writing a single line of code.

## Planning guidelines
The plan you write should be as detailed as possible, removing any ambiguity and locking down all technical decisions before moving to implementation.
It should contain, when relevant:
- A high-level goal and objective for the plan
- A summary of relevant existing context or pieces of code the new thing will interact with
- A record of all technical decisions taken during planning
- An overall architecture breakdown, specifying folder structure, module structure, class structure, different methods, information flow etc.
- A more detailed look at some critical modules if relevant, down to the detail of specific function signatures or variable names if necessary.
- An implementation plan, broken down into commits following the guidelines [here](## Be mindful of your commits, use git features)
- The testing strategy: what scenarios to test, what automated tests to write and their breakdown into unit, integration and e2e, any manual QA necessary.

# Preferred code and implementation styles
TBD
