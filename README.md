# FinTrack – PostgreSQL Schema & Seeds

[![CI](https://github.com/aakashtiwarisolutions/financial-db/actions/workflows/ci.yml/badge.svg)](https://github.com/aakashtiwarisolutions/<REPO>/actions/workflows/ci.yml)
![License](https://img.shields.io/github/license/aakashtiwarisolutions/<REPO>?style=flat-square)
![Last Commit](https://img.shields.io/github/last-commit/aakashtiwarisolutions/<REPO>?style=flat-square)
![Issues](https://img.shields.io/github/issues/aakashtiwarisolutions/<REPO>?style=flat-square)
![Stars](https://img.shields.io/github/stars/aakashtiwarisolutions/<REPO>?style=flat-square)

FinTrack is a lightweight PostgreSQL schema that helps you store basic **users** and their **financial notes** (expenses, sources, balances). It’s simple, readable, and easy to extend for personal finance apps, dashboards, or coursework.

---

## What’s inside

- **Schema name:** `Financial`
- **Tables**
  - `Financial. Users`
    - `ID` *(PK, serial)*  
    - `Name` *(text, required)*  
    - `Email` *(text, unique)*  
    - `Phone` *(text)*  
    - `Created At` *(timestamp, defaults to now())*
  - `Financial. Financial Notes`
    - `ID` *(PK, serial)*  
    - `Expense` *(text[])*  
    - `Spend` *(text[])*  
    - `Source` *(text[])*  
    - `Balance Due` *(integer)*  
    - `notes` *(text[])*  
    - `User ID` *(FK → Users.ID, ON UPDATE CASCADE, ON DELETE SET NULL)*
- **Index**
  - `idx_fin_notes_user` on `Financial Notes("User ID")`

> Schema created from `Fintrack.sql` in this repository.

---

## Quick start

### 1) Requirements
- PostgreSQL 14+ (works fine on newer)
- `psql` available in your PATH

### 2) Create a database
```bash
createdb fintrack_dev
```

### 3) Load the schema
```bash
# from the repo root
psql -d fintrack_dev -f Fintrack.sql
```

### 4) Verify it worked
```sql
-- list schemas
\dn

-- list tables in Financial schema
\dt "Financial".*

-- peek columns
\d "Financial"."Users"
\d "Financial"."Financial Notes"
```

---

## Example queries

```sql
-- Create a user
INSERT INTO "Financial"."Users" ("Name","Email","Phone")
VALUES ('Aakash Tiwari','aakash@example.com','+1-555-0101')
RETURNING "ID";

-- Add a note for that user (arrays for expenses/spend/source)
INSERT INTO "Financial"."Financial Notes" ("Expense","Spend","Source","Balance Due","notes","User ID")
VALUES (ARRAY['rent','utilities'], ARRAY['1200','150'], ARRAY['bank'], 0, ARRAY['paid on time'], 1);

-- Join users with their notes
SELECT u."Name", n."Expense", n."Spend", n."Balance Due"
FROM "Financial"."Users" u
LEFT JOIN "Financial"."Financial Notes" n ON n."User ID" = u."ID";
```

---

## Project structure (suggested)

```
.
├─ Fintrack.sql             # main schema (committed)
├─ sql/                     # optional: hand-written scripts
│  ├─ schema.sql
│  └─ seed.sql
├─ .gitignore
├─ .gitattributes
└─ README.md
```

**.gitignore (safe defaults)**  
```
# OS
.DS_Store
Thumbs.db

# Secrets
.env
*.key
*.pem

# Huge binary backups (prefer plain .sql)
*.backup
```

**.gitattributes (clean diffs)**  
```
*.sql text eol=lf
```

---

## Extending the schema

- Add **categories** (e.g., `Category` table) and connect to `Financial Notes`.
- Convert text arrays into normalized tables for **expenses** and **sources**.
- Add **check constraints** (e.g., `Balance Due >= 0`).
- Add **triggers** for updated timestamps.

---

## CI suggestion (optional)

Create `.github/workflows/ci.yml` to lint and smoke-test SQL (adjust to your setup):

```yaml
name: CI
on: [push, pull_request]
jobs:
  psql-validate:
    runs-on: ubuntu-latest
    services:
      postgres:
        image: postgres:16
        env:
          POSTGRES_PASSWORD: postgres
        ports: ['5432:5432']
        options: >-
          --health-cmd "pg_isready -U postgres"
          --health-interval 5s
          --health-timeout 5s
          --health-retries 20
    steps:
      - uses: actions/checkout@v4
      - name: Wait for Postgres
        run: |
          until pg_isready -h localhost -U postgres; do
            sleep 1
          done
      - name: Install psql
        run: sudo apt-get update && sudo apt-get install -y postgresql-client
      - name: Apply schema
        env:
          PGPASSWORD: postgres
        run: psql -h localhost -U postgres -d postgres -f Fintrack.sql
```

This will make your **build badge** work and ensures the schema always loads.

---

## License

Choose a license (MIT is common for examples). Update the badge at the top accordingly.

---

## Notes on badges

Above badges use your username `aakashtiwarisolutions` and a placeholder `<REPO>`. After you create/push your repo, replace `<REPO>` with your actual repository name. If you keep the workflow file name as `ci.yml`, the CI badge will work automatically.

---

## Credits

- PostgreSQL community ❤️
- You, for keeping finances tidy and transparent.
