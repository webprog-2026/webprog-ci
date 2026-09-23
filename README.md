# webprog-ci

Közös GitHub Actions workflow a webprogramozás házi feladatokhoz. A hallgatói repókban csak egy pár soros hívás van, minden lépés itt fut. **Ha itt javítunk valamit, az azonnal érvényes minden hallgatónál**, nekik nem kell újra push-olniuk.

## Mit ellenőriz

1. **Kötelező fájlok** megléte (a hívásban megadott lista)
2. **PHP szintaxis** (`php -l`) minden `.php` fájlra
3. **Tesztek:** a `tests/test_*.php` fájlok sorban lefutnak. Aki 0-val lép ki, sikeres.

Az eredmény összefoglalója a futás oldalán (Summary) jelenik meg, a részletek teszt szerint csoportosítva a naplóban.

## Hívás a hallgatói repóból

`.github/workflows/check.yml`:

```yaml
name: Ellenőrzés

on:
  push:
  pull_request:
  workflow_dispatch:

jobs:
  check:
    uses: webprog-2026/webprog-ci/.github/workflows/php.yml@main
    with:
      php-version: '8.2'
      required-files: 'profile.php types.php calculator.php grades.php'
```

Paraméterek: `php-version` (alap: 8.2), `required-files` (alap: üres, ilyenkor nincs fájlellenőrzés), `tests-dir` (alap: `tests`).

---

## Új házi feladat létrehozása

1. **Új repó a sablonból.** A legegyszerűbb az előző házi sablonjából indulni:
   ```bash
   gh repo create webprog-2026/wp-hf02-<tema> --private --template webprog-2026/wp-hf01-php-alapok
   ```
2. **README.md:** a feladatkiírás. A követelményeket pontosan úgy fogalmazd meg, ahogy a teszt ellenőrzi (fájlnevek, függvénynevek, megadott tömbök).
3. **`.github/workflows/check.yml`:** csak a `required-files` sort kell átírni.
4. **`tests/`:** a régi `test_*.php` fájlokat cseréld az új feladatokra. A `tests/lib/check.php` marad változatlanul.
5. **Referencia-megoldás:** írd meg a saját megoldásodat egy külön privát repóban (pl. `wp-hf02-referencia`), és futtasd rá a teszteket. Ha a jó megoldás nem megy át, a teszt túl szigorú.
6. **Repó sablonná tétele:**
   ```bash
   gh repo edit webprog-2026/wp-hf02-<tema> --template
   ```
7. **Kiosztás** a hallgatóknak (lásd a következő szakaszt).

### Tesztírás – rövid útmutató

A `tests/lib/check.php` a következőket adja:

| Függvény | Mit csinál |
|---|---|
| `run_php('fajl.php')` | Külön folyamatban lefuttatja, visszaadja a kimenetet |
| `source('fajl.php')` | A forráskód szövegként |
| `source_without_comments('fajl.php')` | Forráskód megjegyzések nélkül (a komment ne számítson megoldásnak) |
| `has_php_error($out)` | Van-e hibaüzenet vagy warning a kimenetben |
| `Check::ok($feltetel, $uzenet)` | Kötelező feltétel, hamis esetén bukás |
| `Check::warn($feltetel, $uzenet)` | Csak figyelmeztetés |
| `Check::contains($szoveg, $reszlet, $uzenet)` | Tartalmazás-vizsgálat |
| `Check::matches($szoveg, $regex, $uzenet)` | Reguláris kifejezés |
| `Check::countAtLeast($szoveg, $reszlet, $n, $uzenet)` | Legalább n előfordulás |
| `Check::finish()` | Összegzés és kilépési kód |

**Elvek:**
- A **kimenetet** teszteld, ne a forráskódot, amikor csak lehet. A forrás-vizsgálat legyen kivétel (pl. „használj heredocot”).
- **Légy megengedő a formátumban:** ne egy konkrét szövegre illessz, hanem a lényegi értékre (`87.6`, `<table`).
- Ami nem egyértelműen elvárás, az `warn()` legyen, ne `ok()`.
- **Mindig futtasd le a referencia-megoldáson**, mielőtt kiadod.

---

## Kiosztás a hallgatóknak

A GitHub Classroom 2026. augusztus 28-án megszűnt, ezért a repók szétosztását az `oktato/assign.sh` végzi.

Névsorfájl (soronként egy GitHub felhasználónév, a `#` utáni rész megjegyzés):

```
# nevsor.txt
kissp            # Kiss Péter
nagyanna
```

Kiosztás:

```bash
./oktato/assign.sh wp-hf01-php-alapok wp-hf01 nevsor.txt
```

Minden hallgatónak létrejön a `wp-hf01-<githubnev>` privát repó a sablonból, és meghívót kap rá **push** joggal (nem admin, tehát nem tudja törölni a repót és nem tudja kikapcsolni az Actions-t). A szkript újrafuttatható: a meglévő repókat kihagyja, így később csatlakozó hallgatóval is működik.

A névsort a hallgatóktól kell összegyűjtened (GitHub felhasználónév), például az első órán egy megosztott táblázatban.

## Beadások áttekintése

```bash
./oktato/report.sh wp-hf01
```

Kiírja az adott házihoz tartozó összes hallgatói repót: utolsó commit ideje és az ellenőrzés eredménye. Így már csak azokat kell kézzel átnézned, amelyek zöldek.
