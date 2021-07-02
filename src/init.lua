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
    args.key = "p"
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

  os.execute("[ ! -p '" .. args.fifo_path .."' ] && mkfifo '" .. args.fifo_path .. "'")

  xplr.fn.custom.preview_tabbed_toggle = function(app)

    if enabled then
      enabled = false
      messages = { "StopFifo" }
    else
      os.execute("NNN_FIFO='" .. args.fifo_path .. "' '".. args.previewer .. "' & ")
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
