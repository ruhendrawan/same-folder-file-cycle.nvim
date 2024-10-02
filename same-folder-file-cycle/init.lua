local M = {}

-- example config: two level ext first, without first dot
M.extensions = {
  primary = "ts",
  secondary = "html",
  allowed = { "spec.ts", "ts", "html", "css" },
}

local last_related_file = ""
local split_window = nil

local function get_file_extension(filename)
  for _, ext in ipairs(M.extensions.allowed) do
    ext = "." .. ext
    if filename:sub(-#ext) == ext then
      return ext
    end
  end
  return nil
end

local function get_base_name(current_file)
  local extension = get_file_extension(current_file)
  if extension then
    return current_file:sub(1, -(#extension + 1))
  else
    return current_file
  end
end

local function get_related_file(base_name, extension)
  local new_file = base_name .. "." .. extension
  if vim.fn.filereadable(new_file) == 1 then
    return new_file
  else
    return nil
  end
end

local function go_to_file(base_name, extension, opts)
  local new_file = get_related_file(base_name, extension)

  if new_file then
    last_related_file = vim.fn.expand("%:p")

    if opts and opts.reuse_window then
      vim.cmd("edit " .. new_file)
    else
      if split_window and vim.api.nvim_win_is_valid(split_window) then
        vim.api.nvim_set_current_win(split_window)
        vim.cmd("edit " .. new_file)
      else
        vim.cmd("split " .. new_file)
        split_window = vim.api.nvim_get_current_win()
      end
    end
  else
    print("File not found: " .. get_base_name() .. "." .. extension)
  end
end

local function cycle_to_ext(target_ext, opts)
  local current_file = vim.fn.expand("%:p")
  local base_name = get_base_name(current_file)
  local current_ext = get_file_extension(current_file)

  if current_ext == "." .. target_ext then
    if current_ext == "." .. M.extensions.primary then
      -- from the main code (.ts) to last related file
      if last_related_file and vim.fn.filereadable(last_related_file) == 1 then
        vim.cmd("edit " .. last_related_file)
      -- or to tempate file (.html)
      else
        go_to_file(base_name, M.extensions.secondary, opts)
      end
    else
      -- from related file to main code (.ts)
      go_to_file(base_name, M.extensions.primary, opts)
    end
  else
    go_to_file(base_name, target_ext, opts)
  end
end

function M.switch_to_ts(opts)
  cycle_to_ext("ts", opts)
end

function M.switch_to_html(opts)
  cycle_to_ext("html", opts)
end
function M.switch_to_css(opts)
  cycle_to_ext("css", opts)
end
function M.switch_to_spec(opts)
  cycle_to_ext("spec.ts", opts)
end

return M
