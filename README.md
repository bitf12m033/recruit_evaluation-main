## Refactor the Lift Update System

### Background

The code in the `cfm` folder is real, working code from a part of our production app. It's used every day — and it shows its age. Your task is to refactor it.

We haven’t added any bugs on purpose, but if you find one, we’d like to hear about it.

You’ll submit a **Pull Request** as your deliverable for this exercise.

The code provided should include everything you need. If you'd like to run it locally, we’ve provided a Docker-based setup. Instructions for this can be found in [`setup.md`](./setup.md).

---

### Estimate

Once you've reviewed the code, open a **draft Pull Request**. The **first comment on the PR** must include your estimate of how long you expect the work to take.

---

### Scope

- We've replaced backend database queries with in-code query structs to simulate sample data. Focus on how these are used in the page — you don’t need to connect to a real database.
- Replacing the jQuery UI **dialog** is optional. If you want to replace it with a modal or similar, go ahead. All **other** jQuery UI usage should be removed.
- ARIA and ADA accessibility requirements are **out of scope**.
- Basic styling via CSS **is expected**.
- **We’re not judging you on design skills**, but the final output should be **legible, user-friendly, and reasonably well-structured**. It should feel like a usable web page, not just raw form elements thrown together.

You should aim to rewrite the `cfm` to include:

- Modern HTML5 markup
- Up-to-date ColdFusion best practices
- Web best practices
- **Vanilla JavaScript only** (no jQuery or jQuery UI, with the exception noted above)
- Table-based layouts **only where appropriate**
- Strong form validation and user experience
  - No bad data should be accepted
  - Errors should be clearly communicated to the user

---

### Style Guidelines

We follow a loose internal style guide. For this exercise, please stick to the following conventions:

- **HTML**

  - IDs: lowercase with underscores (e.g., `user_form`)
  - Classes: lowercase with kebab-case (e.g., `form-container`)
  - Use IDs only for JavaScript hooks
  - Use classes only for styling
  - Prefer `data-` attributes for other metadata or JS hooks

- **JavaScript**
  - Keep in its own file where possible
  - Use `camelCase` for variables and functions, `PascalCase` for classes
  - Use `Prettier` formatting rules

---

### Suggestions

If something in the codebase feels confusing, call it out in your PR or comment. We’re looking for thoughtful and curious developers.

Good luck!
