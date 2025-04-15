local M = {}

local options = {
  prefix = '',
  reg = '+',
}

function M.setup(opts)
  options = vim.tbl_extend('force', options, opts)
end

function M.copy_module_path(buf)
  buf = buf or 0
  local path = vim.api.nvim_buf_get_name(buf)
  local rel_path = vim.fn.fnamemodify(path, ':.h')
  local module_path = string.gsub(rel_path, '/', '.')
  if string.sub(module_path, - #'.py') == '.py' then
    module_path = string.sub(module_path, 1, #module_path - #'.py')
  end
  if options.prefix then
    module_path = options.prefix .. '.' .. module_path
  end
  vim.fn.setreg('+', module_path)
  vim.notify('Copied ' .. module_path, vim.log.levels.INFO)
end

function M.copy_import_path(buf)
  buf = buf or 0
  local path = vim.api.nvim_buf_get_name(buf)
  local rel_path = vim.fn.fnamemodify(path, ':.h')
  local module_path = string.gsub(rel_path, '/', '.')
  if string.sub(module_path, - #'.py') == '.py' then
    module_path = string.sub(module_path, 1, #module_path - #'.py')
  end
  local last_dot = string.find(module_path, '.[^.]*$')
  local file_module = ''
  if last_dot then
    file_module = string.sub(module_path, last_dot + 1)
    module_path = string.sub(module_path, 1, last_dot - 1)
  end
  if options.prefix then
    module_path = options.prefix .. '.' .. module_path
  end
  local import_stmt = 'from ' .. module_path .. ' import ' .. file_module
  vim.fn.setreg('+', import_stmt .. '\n')
  vim.notify('Copied ' .. import_stmt, vim.log.levels.INFO)
end

return M
