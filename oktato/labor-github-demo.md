# Laborvezetői forgatókönyv – a GitHubos munkafolyamat végigjátszása

**Időigény:** 35–45 perc, az első házi feladaton.
**Cél:** a félév végéig egyetlen hallgató se akadjon el a folyamaton, csak a feladaton.

A hallgatók a saját gépükön csinálják végig veled együtt. Te kivetítesz, és **szándékosan hibázol is** — a hibák megmutatása többet ér, mint a sima út.

---

## 0. Előkészület (a labor előtt)

- [ ] Mindenki elfogadta a meghívót? `ORG=webprog-2026 ./oktato/csapat.sh`
- [ ] Van-e a gépeken **git**? (`git --version`) Ha nincs, ez az első 5 perc.
- [ ] Készíts magadnak egy demó-repót, amit nyugodtan elronthatsz: `wp-hf01-demo`
- [ ] A kivetítőn növeld meg a betűméretet a terminálban és a böngészőben is.

---

## 1. Miért? (5 perc, kivetítőn, gép nélkül)

Ne a gombokkal kezdd, hanem azzal, mire jó.

- **Verziókezelés:** „ki írta, mikor, miért" — és bármikor vissza lehet lépni. Kérdezd meg, ki dolgozott már úgy, hogy `dolgozat_vegleges_2_JAVITOTT.docx`. Ez az a probléma, amit a git megold.
- **A szakmában ez a szabvány.** Az első munkahelyi napon ezt fogják kérni.
- **Automatikus ellenőrzés:** azonnal látják, működik-e a megoldás, nem kell az értékelésre várni.

Egy ábra a táblára:

```
sablon  --(Use this template)-->  saját repó  --(clone)-->  a gépem
                                      ^                        |
                                      +--------(push)----------+
```

---

## 2. A saját repó létrehozása (5 perc)

Közösen, mindenki a saját gépén:

1. A sablon linkje a Classroomban → megnyitják.
2. **Mutasd meg, hogy ide nem tudnak írni** — próbálj meg szerkeszteni egy fájlt a sablonban. Ez teszi érthetővé, miért kell másolat.
3. **Use this template → Create a new repository**
   - Owner: `webprog-2026` — állítsd rá a figyelmet, hogy alapból a saját nevük van ott
   - Repository name: `wp-hf01-<felhasználónevük>` — mondd ki, hogy a csúcsos zárójelet ne írják be
   - Private
4. Mindenkinél létrejött? Ez jó pont a körbenézésre.

> **Gyakori hiba:** a valódi nevüket írják be a felhasználónév helyett. Mutasd meg, hol látják a felhasználónevüket (jobb felső sarok, vagy a profil URL-je).

---

## 3. Klónozás (5 perc)

```bash
git clone https://github.com/webprog-2026/wp-hf01-<felhasznalonev>.git
cd wp-hf01-<felhasznalonev>
ls
```

Beszéld meg, mit látnak: `README.md`, `tests/`, `.github/`. Nyisd meg a `README.md`-t, és mutasd meg, hogy **a feladat leírása is a repóban van**.

Első hitelesítéskor a git bejelentkezést kér (böngészőben). Erre készülj, mert itt szoktak elakadni.

---

## 4. Az első commit – szándékosan hibásan (10 perc)

Ez a rész a leghasznosabb. Készítsd el a `profile.php`-t **hiányosan**: legyen benne két változó és egy `echo`, semmi más.

```bash
git add .
git commit -m "profile.php kezdete"
git push
```

Magyarázd el a három lépést, mert ezt sokan összemossák:
- `add` — kijelölöm, mi kerüljön bele a mentésbe
- `commit` — mentés a saját gépemen, üzenettel
- `push` — feltöltés a GitHubra

Aztán **együtt nézzétek meg az Actions fület**: sárga pötty, majd piros X. Kattints bele, és olvassátok el a naplót:

```
OK   Létezik a $name változó
HIBA A kimenet tartalmaz <em> címkét
```

Ez a pillanat a lényeg: **a hiba nem baj, hanem visszajelzés.** Mondd ki, hogy a piros X nem jegy, és senki nem kap érte levonást.

---

## 5. Javítás és zöld (5 perc)

Egészítsd ki a fájlt, és:

```bash
git add .
git commit -m "profile.php kesz"
git push
```

Frissítsétek az Actions fület: zöld pipa.

Itt tedd hozzá: **a zöld pipa sem jegy.** Azt jelenti, hogy a kötelező elemek megvannak. A megoldás minőségét te értékeled.

---

## 6. Amit érdemes még megmutatni (5–10 perc)

- **Commit-üzenetek:** hasonlítsátok össze a „Add files via upload" és a „jegykalkulator: switch ag hozzaadasa" üzenetet. Melyikből derül ki, mi történt?
- **A History fül:** látszik minden korábbi állapot, és vissza lehet nézni, mi változott.
- **Helyi futtatás:** `php profile.php`, illetve `php tests/test_profile.php` — ugyanaz a teszt, ami a GitHubon fut, csak gyorsabb.
- **Issue nyitása:** ha elakadnak, a saját repójukban nyithatnak egyet, és te látod a kódjukat.

---

## 7. Zárás

Mondd el, mi a dolguk:

1. Ma otthon: befejezni a négy fájlt, push-olni, és megnézni, zöld-e.
2. Nyugodtan tölthetnek fel sokszor, akár félkész állapotban is.
3. A határidőkor a repóban lévő utolsó állapot számít.

---

## Amire készülj

| Probléma | Megoldás |
|---|---|
| Nincs git a gépen | git-scm.com, telepítés alapbeállításokkal |
| A git nevet és e-mailt kér | `git config --global user.name "..."`, `user.email "..."` |
| Bejelentkezési hurok | A hitelesítés böngészőben történik, néha egy ablakot be kell zárni |
| Nem látja a sablont | Nincs a `hallgatok` csapatban: futtasd a `csapat.sh`-t |
| Rossz helyre hozta létre a repót | Settings → Transfer ownership, vagy új repó a jó helyen |
| Elrontotta a repó nevét | Settings → Repository name, vagy a `nevek.sh --javit` |

## Utána

A labor végén nézd meg, hol tartanak:

```bash
ORG=webprog-2026 ./oktato/report.sh wp-hf01
```

Aki `ÜRES`, annál a folyamat akadt el, nem a feladat — azt érdemes még a laboron elkapni.
