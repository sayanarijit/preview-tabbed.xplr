local q = xplr.util.shell_quote

local function parse_args(args)
  if args == nil then
    args = {}
  end

  if args.fifo_path == nil then
    args.fifo_path = "/tmp/xplr.fifo"
  end

  if args.mode == nil then
    args.mode = "action"
  end

  if args.key == nil then
    args.key = "P"
  end

  if args.previewer == nil then
    args.previewer = os.getenv("HOME") .. "/.config/nnn/plugins/preview-tabbed"
  end

  return args
end

local function setup(args)
  args = parse_args(args)

  local xplr = xplr

  local enabled = false
  local messages = {}

  xplr.fn.custom.preview_tabbed_toggle = function(app)
    os.execute("test -p " .. q(args.fifo_path) .. " || mkfifo " .. q(args.fifo_path))

    if enabled then
      enabled = false
      messages = { "StopFifo" }
    else
      os.execute("NNN_FIFO=" .. q(args.fifo_path) .. " " .. q(args.previewer) .. " &")
      enabled = true
      messages = {
        { StartFifo = args.fifo_path },
      }
    end

    return messages
  end

  xplr.config.modes.builtin[args.mode].key_bindings.on_key[args.key] = {
    help = "toggle preview",
    messages = {
      "PopMode",
      { CallLuaSilently = "custom.preview_tabbed_toggle" },
    },
  }
end

return { setup = setup }
