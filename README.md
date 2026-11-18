# Chełmek Explore 2.0

## Zagraj

[**Uruchom grę online**](https://chelmek-explore.vercel.app/)

Gra jest przeglądarkowym, trójwymiarowym spacerem po Chełmku. Sterowanie po wejściu do świata: **WASD** — ruch, **Shift** — bieg, **Spacja** — skok/hamulec, **E** — wsiądź/wysiądź/interakcja, **C** — kamera, **T** — pora dnia, **P** — efekty, mysz — obrót.

## Uruchom lokalnie

Wymagany jest Python 3. W katalogu głównym repozytorium uruchom:

```bash
python3 -m http.server 8000 --directory public
```

Następnie otwórz <http://localhost:8000/>. Gra korzysta z modułów i usług mapowych ładowanych w przeglądarce; do pełnego działania potrzebne jest połączenie z internetem.

## Źródło i zakres repozytorium

Bazą wizualną i działającą wersją jest [obecne wdrożenie Vercel](https://chelmek-explore.vercel.app/), wskazane w zleceniu. Oryginalne repozytorium [`Che-mek-EXPLORE-2.0`](https://github.com/amadii90210-dev/Che-mek-EXPLORE-2.0) zawierało wyłącznie README, dlatego `public/` przechowuje statyczny snapshot plików aplikacji z wdrożenia, a nie odzyskane źródła edytowalne. Projekt pozostaje grą webową opartą na Three.js — repozytorium nie zawiera projektu Unreal Engine 5.

Dane mapy: © autorzy OpenStreetMap (ODbL). Wysokości terenu: Mapzen Terrain Tiles. Zachowano atrybucję z bazowej aplikacji.
