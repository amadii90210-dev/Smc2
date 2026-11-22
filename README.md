# Chełmek Explore 2.0

## Zagraj online

[**Uruchom grę na GitHub Pages**](https://amadii90210-dev.github.io/Smc2/)

Gra jest przeglądarkowym, trójwymiarowym spacerem po Chełmku. Sterowanie po wejściu do świata: **WASD** — ruch, **Shift** — bieg, **Spacja** — skok/hamulec, **E** — wsiądź/wysiądź/interakcja, **C** — kamera, **T** — pora dnia, **P** — efekty, mysz — obrót. Interfejs dotykowy działa na telefonach.

## Uruchom lokalnie

Wymagany jest Python 3. W katalogu głównym repozytorium uruchom:

```bash
python3 -m http.server 8000 --directory public
```

Następnie otwórz <http://localhost:8000/>. Gra korzysta z modułów i usług mapowych ładowanych w przeglądarce; do pełnego działania potrzebne jest połączenie z internetem.

## Źródło i zakres repozytorium

`public/` przechowuje statyczny pakiet działającej gry Three.js. Ulepszona wersja obejmuje m.in. fixed-step motion, sprężystą kamerę, pooled tire smoke/skid marks, adaptive mobile rendering, chunk culling oraz istniejące dane świata i sterowanie.

Dane mapy: © autorzy OpenStreetMap (ODbL). Wysokości terenu: Mapzen Terrain Tiles. Zachowano atrybucję z bazowej aplikacji.
