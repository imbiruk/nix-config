$env.config = {
  show_banner: false
}

$env.config = ($env.config | upsert hooks.pre_prompt [{
  code: {||
    let out = (direnv export json | complete)
    if $out.exit_code != 0 or ($out.stdout | str trim | is-empty) { return }
    $out.stdout | from json | load-env
  }
}])
