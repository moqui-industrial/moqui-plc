# Code generation workspace

`codegen/` holds the work the agent skills in [`.agents/skills`](../.agents/skills)
produce. The skills are versioned tooling; this directory is their output.

```text
codegen/
├── CURRENT_SESSION        # id of the active session, read by AGENTS.md at startup
├── sessions/
│   └── <session-id>/      # one resumable session (see session-layout.md)
│       ├── session.json
│       ├── survey-answers/
│       ├── seed-data/
│       ├── generated-plc/
│       ├── generated-recipes/
│       ├── generated-config/
│       ├── notes/
│       └── exports/
├── seed-designer/         # standalone seed examples
└── target/                # ad-hoc script output when no session is given (gitignored)
```

The session layout is specified in
[`.agents/skills/moqui-plant-designer/references/session-layout.md`](../.agents/skills/moqui-plant-designer/references/session-layout.md).

## What is versioned

Session state, survey answers, reviewed seed data, generated PLC code and notes
are versioned, so a session can be resumed on another machine and serves as a
reviewed example. ZIP exports, export manifests, source snapshots and
`target/` stay local (see the repository `.gitignore`). Never commit
credentials, database contents or runtime logs.

## Reviewed example sessions

| Session | Project | Status | Contains |
| --- | --- | --- | --- |
| `hvac-e2e-20260716` | Moqui Industrial HVAC end-to-end validation (the default `CURRENT_SESSION`) | in progress | surveys, seed data, notes |
| `demo-plant-session` | Demo plant | in progress | seed data, generated PLC, recipes, config, exports |
| `tank-level-control-001` | Tank level feedback control | needs review | surveys, seed data, generated PLC, notes |
| `isothermal-reactor-001` | Isothermal CSTR concentration control | needs review | surveys, seed data, generated PLC, notes |
| `skills-hardening-20260619-plc4j` | Skill hardening with `moqui-plc4j` | needs review | surveys, notes, exports |

## Starting a new session

From the `moqui-plc` root:

```bash
python3 .agents/skills/moqui-plant-designer/scripts/init_session.py <session-id>
```

The session is created in `codegen/sessions/<session-id>/`. Write its id to
`codegen/CURRENT_SESSION` to make it the session agents resume.
