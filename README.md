# FinTrack – PostgreSQL Schema & Seeds

[![CI](https://github.com/aakashtiwarisolutions/financial-db/actions/workflows/ci.yml/badge.svg)](https://github.com/aakashtiwarisolutions/financial-db/actions/workflows/ci.yml)
![License](https://img.shields.io/github/license/aakashtiwarisolutions/financial-db?style=flat-square)
![Last Commit](https://img.shields.io/github/last-commit/aakashtiwarisolutions/financial-db?style=flat-square)
![Issues](https://img.shields.io/github/issues/aakashtiwarisolutions/financial-db?style=flat-square)
![Stars](https://img.shields.io/github/stars/aakashtiwarisolutions/financial-db?style=flat-square)

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

## Quick start:

### 1) Requirements:
- PostgreSQL 14+ (newer works)
- `psql` available in your PATH

### 2) Create a database:
```bash
createdb fintrack_dev
