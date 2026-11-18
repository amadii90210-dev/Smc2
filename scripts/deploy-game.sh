#!/usr/bin/env bash
set -Eeuo pipefail

# Deploy the Chełmek Explore static game from public/ to Netlify or Vercel.
# No build is needed: index.html, app.js, and world.json are already static assets.

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd -- "$SCRIPT_DIR/.." && pwd)"
SITE_DIR="$REPO_ROOT/public"
PROVIDER="${HOSTING_PROVIDER:-netlify}"
CHECK_ONLY=false

usage() {
  cat <<'EOF'
Deploy Chełmek Explore to a static hosting provider.

Usage:
  scripts/deploy-game.sh [--provider netlify|vercel] [--dir PATH] [--check]

Options:
  --provider NAME  Hosting provider (default: netlify; also: vercel)
  --dir PATH       Static site directory (default: repository-root/public)
  --check          Validate required files and print the selected target; do not deploy
  -h, --help       Show this help

Authentication:
  Netlify: set NETLIFY_SITE_ID and NETLIFY_AUTH_TOKEN, or log in with `netlify login`.
  Vercel: set VERCEL_TOKEN, or log in with `vercel login`. For a team, optionally set
          VERCEL_SCOPE. The token is never written to the repository or printed.

The Netlify deployment targets the existing site named by NETLIFY_SITE_ID.
Vercel deploys the static directory as a production deployment. Run the script only
when you intend to publish the current contents of that directory.
EOF
}

while (($#)); do
  case "$1" in
    --provider)
      [[ $# -ge 2 ]] || { echo "Missing value for --provider" >&2; exit 2; }
      PROVIDER="$2"
      shift 2
      ;;
    --dir)
      [[ $# -ge 2 ]] || { echo "Missing value for --dir" >&2; exit 2; }
      SITE_DIR="$2"
      shift 2
      ;;
    --check)
      CHECK_ONLY=true
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown option: $1" >&2
      usage >&2
      exit 2
      ;;
  esac
done

case "$PROVIDER" in
  netlify|vercel) ;;
  *) echo "Unsupported provider '$PROVIDER' (choose netlify or vercel)." >&2; exit 2 ;;
esac

if [[ ! "$SITE_DIR" = /* ]]; then
  SITE_DIR="$PWD/$SITE_DIR"
fi
if [[ ! -d "$SITE_DIR" ]]; then
  echo "Static site directory not found: $SITE_DIR" >&2
  exit 1
fi
SITE_DIR="$(cd -- "$SITE_DIR" && pwd)"

for file in index.html app.js world.json; do
  if [[ ! -s "$SITE_DIR/$file" ]]; then
    echo "Required game file is missing or empty: $SITE_DIR/$file" >&2
    exit 1
  fi
done

printf 'Site directory: %s\nProvider: %s\n' "$SITE_DIR" "$PROVIDER"
if [[ "$CHECK_ONLY" == true ]]; then
  echo 'Preflight OK; no deployment was started.'
  exit 0
fi

need_npx() {
  command -v npx >/dev/null 2>&1 || {
    echo "Node.js/npm (npx) is required when the provider CLI is not installed." >&2
    exit 1
  }
}

case "$PROVIDER" in
  netlify)
    [[ -n "${NETLIFY_SITE_ID:-}" ]] || {
      echo "Set NETLIFY_SITE_ID to the existing Netlify site's Project ID." >&2
      exit 1
    }
    if command -v netlify >/dev/null 2>&1; then
      NETLIFY_CLI=(netlify)
    else
      need_npx
      NETLIFY_CLI=(npx --yes netlify-cli@latest)
    fi
    if [[ -z "${NETLIFY_AUTH_TOKEN:-}" ]] && ! "${NETLIFY_CLI[@]}" status >/dev/null 2>&1; then
      echo "Netlify authentication missing. Set NETLIFY_AUTH_TOKEN or run 'netlify login'." >&2
      exit 1
    fi
    echo 'Deploying static files to the selected Netlify site...'
    "${NETLIFY_CLI[@]}" deploy \
      --dir "$SITE_DIR" \
      --site "$NETLIFY_SITE_ID" \
      --prod \
      --no-build \
      --message "Chełmek Explore deployment"
    ;;
  vercel)
    if command -v vercel >/dev/null 2>&1; then
      VERCEL_CLI=(vercel)
    else
      need_npx
      VERCEL_CLI=(npx --yes vercel@latest)
    fi
    if [[ -z "${VERCEL_TOKEN:-}" ]] && ! "${VERCEL_CLI[@]}" whoami >/dev/null 2>&1; then
      echo "Vercel authentication missing. Set VERCEL_TOKEN or run 'vercel login'." >&2
      exit 1
    fi
    VERCEL_ARGS=(deploy --prod --yes --cwd "$SITE_DIR")
    if [[ -n "${VERCEL_SCOPE:-}" ]]; then
      VERCEL_ARGS+=(--scope "$VERCEL_SCOPE")
    fi
    if [[ -n "${VERCEL_TOKEN:-}" ]]; then
      VERCEL_ARGS+=(--token "$VERCEL_TOKEN")
    fi
    echo 'Deploying the static game to Vercel production...'
    "${VERCEL_CLI[@]}" "${VERCEL_ARGS[@]}"
    ;;
esac
