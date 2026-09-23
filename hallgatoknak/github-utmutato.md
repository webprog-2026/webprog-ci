# Útmutató a házi feladatok beadásához

A házi feladatokat GitHubon adod be. Ez az útmutató végigvezet a teljes folyamaton: fiók létrehozása, meghívó elfogadása, a saját repó létrehozása, munka és beadás.

Egyszer kell végigcsinálnod az 1–2. lépést, utána minden házinál csak a 3. lépéstől indulsz.

---

## 1. GitHub-fiók létrehozása

Ha még nincs fiókod:

1. Nyisd meg a [github.com/signup](https://github.com/signup) oldalt.
2. Add meg az **egyetemi e-mail címedet** (arra érkezik a meghívó).
3. Válassz jelszót és felhasználónevet.
   - A felhasználónév nyilvános, és a későbbiekben is használni fogod. Válassz komolyat: `kiss.peter`, `pkiss99` és hasonló. Ne fantázianevet.
4. Erősítsd meg az e-mail címedet a kapott levélben.

Ha már van fiókod, ezt a lépést kihagyhatod. Ellenőrizd viszont a [beállításokban](https://github.com/settings/emails), hogy az egyetemi e-mail címed szerepel-e a fiókodnál. Ha nem, add hozzá.

**Jegyezd meg a felhasználónevedet.** Ezt a profilod címében látod: `github.com/<felhasználónév>`.

---

## 2. A meghívó elfogadása

A kurzus szervezetébe (`webprog-2026`) e-mailben kapsz meghívót.

1. Nyisd meg a levelet, és kattints a **Join** gombra.
2. Ha nem vagy bejelentkezve, a GitHub bejelentkezést kér. Jelentkezz be a saját fiókodba.
3. Ha nincs még fiókod, a rendszer a regisztrációra visz, és utána automatikusan visszatér a meghívóhoz.

Ha megvan, a [github.com/webprog-2026](https://github.com/webprog-2026) oldalon látod a szervezetet.

> **Nem kaptad meg a levelet?** Nézd meg a spam mappát is. Ha ott sincs, szólj az oktatónak, melyik e-mail címre várod.

---

## 3. A saját repó létrehozása a feladathoz

Minden házi feladathoz kapsz egy **sablon linket**. Ezt nyisd meg, és kattints a zöld **Use this template → Create a new repository** gombra.

A megjelenő űrlapon:

| Mező | Mit adj meg |
|---|---|
| **Owner** | `webprog-2026` (a legördülő listából, ne a saját neved) |
| **Repository name** | `wp-hf01-<felhasználóneved>`, például `wp-hf01-pkiss99` |
| **Description** | üresen hagyható |
| **Visibility** | **Private** |

Végül **Create repository**.

> **Fontos:** a repó nevében pontosan az a felhasználónév szerepeljen, amivel be vagy jelentkezve. Ez alapján találja meg az oktató a beadásodat. A házi sorszáma (`wp-hf01`, `wp-hf02`, …) mindig a feladat kiírásában szerepel.

A repódban ott lesz a feladat leírása (`README.md`) és a tesztek (`tests/` mappa).

---

## 4. Munka a feladaton

Két út közül választhatsz.

### A) Szerkesztés a böngészőben (egyszerűbb)

1. A repódban: **Add file → Create new file**.
2. Add meg a fájl nevét (pl. `profile.php`), írd be a kódot.
3. Lent: **Commit changes**.

Ez gyors, de a kódot nem tudod futtatni, csak a GitHubon lefutó teszt mondja meg, hogy jó-e.

### B) Munka a saját gépeden (ajánlott)

1. A repód oldalán: **Code → HTTPS**, másold ki a címet.
2. A gépeden:
   ```bash
   git clone https://github.com/webprog-2026/wp-hf01-<felhasznalonev>.git
   cd wp-hf01-<felhasznalonev>
   ```
3. Dolgozz a fájlokon a szokásos szerkesztőddel.
4. Próbáld ki helyben:
   ```bash
   php -l profile.php          # szintaxis-ellenőrzés
   php profile.php             # futtatás, a kimenet HTML
   php tests/test_profile.php  # ugyanaz a teszt, ami a GitHubon fut
   ```
5. Feltöltés:
   ```bash
   git add .
   git commit -m "1. feladat kesz"
   git push
   ```

Nyugodtan push-olj sokszor, akár félkész állapotban is. Az számít, ami a határidőkor a repóban van.

---

## 5. Az automatikus ellenőrzés

Minden feltöltés után automatikusan lefut egy ellenőrzés. Az eredményt a repód **Actions** fülén látod, és a commit mellett is megjelenik egy jelzés:

- 🟡 **sárga pötty:** most fut, várj fél percet
- ✅ **zöld pipa:** minden kötelező feltétel teljesül
- ❌ **piros X:** valami hiányzik

**Piros X esetén:** kattints rá, majd a bal oldalon a `check` feladatra. A naplóban feladatonként látod a részleteket:

```
OK   Létezik a $name változó
HIBA A kimenet tartalmaz <em> címkét
```

A `HIBA` sorok mutatják, mit kell még pótolnod. A `FIGYELEM` sorok csak javaslatok, azoktól nem bukik meg az ellenőrzés.

**Fontos tudni:**
- Az automatikus teszt **nem jegy**. Azt nézi, hogy a kód lefut-e, és megvannak-e az előírt elemek. A megoldás minőségét az oktató értékeli.
- A zöld pipa nem jelenti automatikusan a maximális pontot, a piros X viszont majdnem biztosan pontlevonás.

---

## 6. Beadás

Külön beadás nincs: **a határidőkor a repódban lévő utolsó állapot számít.** Csak arra figyelj, hogy a munkád fel is legyen push-olva.

---

## Gyakori hibák

| Tünet | Megoldás |
|---|---|
| A repó a saját fiókom alatt jött létre | Settings → Transfer ownership, vagy hozz létre újat jó helyen |
| Elrontottam a repó nevét | Settings → Repository name → átnevezés |
| Nem fut le az ellenőrzés | Nézd meg, hogy megvan-e a `.github` mappa. Ne töröld! |
| „Hiányzó fájl" hibát kapok, pedig megírtam | A fájl a repó gyökerében legyen, és pontosan a megadott néven (kis- és nagybetű számít) |
| A tesztek hibásan buknak meg | Szólj az oktatónak. Előfordulhat, hogy a teszt túl szigorú |

**Amit ne csinálj:** ne módosítsd a `tests/` és a `.github/` mappát, és ne töröld őket. Ezek az ellenőrzéshez kellenek.

---

## Segítség

Ha elakadsz: írj az oktatónak, vagy nyiss egy **Issue**-t a saját repódban. Az oktató látja a repódat, így a konkrét hibát is meg tudja nézni.
