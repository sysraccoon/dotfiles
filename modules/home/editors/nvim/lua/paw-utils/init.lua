local scan = require "plenary.scandir"
local M = {}

local function buffer_content_as_string()
  local buffer_lines = vim.api.nvim_buf_get_lines(0, 0, vim.api.nvim_buf_line_count(0), false)
  local buffer_content = table.concat(buffer_lines, "\n")
  return buffer_content
end

local function write_all(filepath, content)
  local file = io.open(filepath, "w")
  if file ~= nil then
    print(content)
    file:write(content)
    file:close()
  else
    error("write_all: file is nil")
  end
end

function M.paw_save_state()
  local buffer_content = buffer_content_as_string()
  local filename = vim.fn.expand("%:t")
  local relative_filepath = vim.fn.expand("%:.")
  local state = {
    filepath = relative_filepath,
    content = buffer_content,
  }
  local json_state = vim.json.encode(state)

  local output_dir = "paw_output"
  vim.fn.mkdir(output_dir, "p")
  local exist_output_files = scan.scan_dir(output_dir, { hidden = true, depth = 1 })
  local current_max_file_index = 0
  for _, value in ipairs(exist_output_files) do
    local match = vim.fn.matchlist(value, '\\(\\d\\+\\)')

    if #match < 2 then
      goto continue
    end

    local file_index = tonumber(match[1])

    if file_index == nil then
      goto continue
    end

    if file_index > current_max_file_index then
      current_max_file_index = file_index
    end
    ::continue::
  end
  local file_index = string.format("%04d", current_max_file_index + 1)
  local result_filename = file_index .. "-" .. filename:gsub("[.]", "-") .. ".json"
  local output_path = output_dir .. "/" .. result_filename

  write_all(output_path, json_state)
  print("save state as " .. output_path)
end

return M
