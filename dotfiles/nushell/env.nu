let extra_paths = [
  "/run/wrappers/bin"
  $"($env.HOME)/.local/bin"
  $"($env.HOME)/.cargo/bin"
  $"($env.HOME)/.nix-profile/bin"
  "/etc/profiles/per-user/biruk/bin"
  "/nix/var/nix/profiles/default/bin"
  "/run/current-system/sw/bin"
]

$env.PATH = (
  $extra_paths
  | append ($env.PATH? | default [])
  | uniq
)

$env.EDITOR = "nvim"
$env.VISUAL = "nvim"
