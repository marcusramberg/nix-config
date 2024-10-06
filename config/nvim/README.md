# LazyVim

[LazyVim](https://github.com/LazyVim/LazyVim) config for [marcus](https://github.com/marcusramberg)

I've been stripping this down a bit over time, trying to mostly use the extras
and not too much custom stuff.

Currently using ld-config on nixos to allow mason to control lsps.

Refer to the comments in the files on how to customize **LazyVim**.

## 📂 File Structure

```ascii
~/.config/nvim
├── lua
│   ├── config
│   │   ├── autocmds.lua
│   │   ├── keymaps.lua
│   │   ├── lazy.lua
│   │   └── options.lua
│   └── plugins
│       └── example.lua
├── init.lua
└── stylua.toml
```
