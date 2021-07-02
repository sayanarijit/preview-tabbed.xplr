![preview gif](https://user-images.githubusercontent.com/11632726/120893313-40a1af80-c630-11eb-800d-815ca3aadb5c.gif)

Preview paths using suckless [tabbed](https://tools.suckless.org/tabbed/) and
[nnn preview-tabbed](https://github.com/jarun/nnn/blob/master/plugins/preview-tabbed).


Requirements
------------

- [nnn](https://github.com/jarun/nnn) with
  [plugins](https://github.com/jarun/nnn/tree/master/plugins#nnn-plugins)
  (specifically [preview-tabbed](https://github.com/jarun/nnn/blob/master/plugins/preview-tabbed)
  and
  [nuke](https://github.com/jarun/nnn/blob/master/plugins/nuke))
- [tabbed](https://tools.suckless.org/tabbed) (xembed host)
- [xterm](https://invisible-island.net/xterm/) (or [urxvt](https://software.schmorp.de/pkg/rxvt-unicode.html) or [st](https://st.suckless.org/))
- [mpv](https://mpv.io) (xembed client for video/audio)
- [sxiv](https://github.com/muennich/sxiv) (xembed client for images)
- [zathura](https://pwmt.org/projects/zathura) (xembed client for PDF)
- [vim](https://www.vim.org) (or any editor/pager really)
- file
- mktemp
- [xdotool](https://github.com/jordansissel/xdotool) (optional, to keep main window focused)


TODO: Reduce dependencies as much as possible.


Installation
------------

### Install manually

- Add the following line in `~/.config/xplr/init.lua`

  ```lua
  package.path = os.getenv("HOME") .. '/.config/xplr/plugins/?/src/init.lua'
  ```

- Clone the plugin

  ```bash
  mkdir -p ~/.config/xplr/plugins

  git clone https://github.com/sayanarijit/preview-tabbed.xplr ~/.config/xplr/plugins/preview-tabbed
  ```

- Require the module in `~/.config/xplr/init.lua`

  ```lua
  require("preview-tabbed").setup()
  
  -- Or
  
  require("preview-tabbed").setup{
    mode = "action",
    key = "p",
    fifo_path = "/tmp/xplr.fifo",
    previewer = os.getenv("HOME") .. "/.config/nnn/plugins/preview-tabbed",
  }

  -- Type `:p` to toggle preview mode.
  ```

Troubleshooting
---------------

1. **Getting `Permission denied`**

   Make sure `~/.config/nnn/plugins/*` scripts have execute permission.
   
   ```
   chmod +x ~/.config/nnn/plugins/*
   ```

2. **xplr gets stuck and it's difficult to debug**

   This is the FIFO doing its job.
   
   Run `cat /path/to/fifo` in another window while xplr is stuck/running. Keep
   both running. This will keep clearing the FIFO buffer as you use xplr.

3. **Window focus gets lost in XMonad**

   As [@mrdgo pointed out](https://github.com/sayanarijit/xplr/issues/258#issuecomment-860037317), this should do the trick:

   ```haskell
   import XMonad.Hooks.EwmhDesktops (ewmh)
   -- xmonad config
   main = do
       xmonad $ ewmh $ def {...}
   ```
