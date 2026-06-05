#!/usr/bin/env bash

set -Eeuo pipefail

readonly CONFIG_DIR="${HOME}/.config"
readonly DOTDIR="${HOME}/tech-notes/dotfiles/.config"
readonly LOG_DIR="${HOME}/.cache"
readonly LOG_FILE="${LOG_DIR}/dots-install-$(date +%Y%m%d_%H%M%S).log"

# Expected configuration folders in the repo
readonly CONFIG_FOLDERS=(
  atuin fastfetch fish foot kitty niri nvim mako starship
  swaylock take-note vicinae wallust waybar yazi zathura
)

# ==========================
# COLOR OUTPUT
# ==========================

readonly GREEN='\033[0;32m'
readonly BLUE='\033[0;34m'
readonly YELLOW='\033[1;33m'
readonly RED='\033[0;31m'
readonly NC='\033[0m'

# ==========================
# LOGGING & OUTPUT FUNCTIONS
# ==========================

log() {
  local timestamp
  timestamp="$(date +'%Y-%m-%d %H:%M:%S')"
  printf "[%s] %s\n" "${timestamp}" "$*" >> "${LOG_FILE}" 2> /dev/null || true
}

msg() {
  printf "${GREEN}==>${NC} %s\n" "$1"
  log "INFO: $1"
}

info() {
  printf "${BLUE}==>${NC} %s\n" "$1"
  log "INFO: $1"
}

warn() {
  printf "${YELLOW}[WARNING]${NC} %s\n" "$1"
  log "WARNING: $1"
}

error() {
  printf "${RED}[ERROR]${NC} %s\n" "$1" >&2
  log "ERROR: $1"
}

fatal() {
  error "$1"
  error "Installation failed. Check log file: ${LOG_FILE}"
  exit 1
}

create_symlinks() {
  msg "Creating symbolic links to ~/.config..."
  local linked=0
  local skipped=0

  for folder in "${CONFIG_FOLDERS[@]}"; do
    if [[ -d "${DOTDIR}/${folder}" ]]; then
      local target="${CONFIG_DIR}/${folder}"

      # Safety check for path validation
      if [[ -z "${CONFIG_DIR}" ]] || [[ -z "${target}" ]]; then
        fatal "Path validation failed: CONFIG_DIR or target is empty"
      fi

      if [[ -e "${target}" ]] || [[ -L "${target}" ]]; then
        warn "Target still exists: ${folder} (removing)"
        rm -rf "${target}"
      fi

      if ln -s "${DOTDIR}/${folder}" "${target}" 2>> "${LOG_FILE}"; then
        info "Linked: ${folder}"
        ((++linked)) || true
      else
        error "Failed to link: ${folder} (check log for details)"
      fi
    else
      info "Skipping: ${folder} (not found in repository)"
      ((++skipped)) || true
    fi
  done

  msg "Created ${linked} symlink(s), skipped ${skipped}."
}

create_symlinks
