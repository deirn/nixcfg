# WSL

### Emacs desktop shortcut using VcXsrv
``` cmd
"C:\Program Files\WSL\wslg.exe" -d NixOS --cd "~" -- zsh -elic "use-vcxsrv emacs"
```

### `%USERPROFILE%/.wslconfig`
``` toml
[wsl2]
networkingMode=mirrored
```
