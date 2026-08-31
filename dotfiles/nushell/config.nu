$env.config = {
  show_banner: false
}

$env.config = ($env.config | upsert hooks.pre_prompt [{
  code: {||
    let direnv = (direnv export json | from json --objects | default {})
    if ($direnv | is-empty) { return }
    $direnv | load-env
  }
}])
