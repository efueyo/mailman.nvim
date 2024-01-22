local M = {}

function M.edit(wk_name, env_name, env, on_save)
  --open a new buffer with the environment
  --once saved the environment will be updated

  local buf = vim.api.nvim_create_buf(true, false)
  vim.api.nvim_buf_set_name(buf, "Mailman env " .. wk_name .. " " .. env_name)
  vim.api.nvim_buf_set_option(buf, "bufhidden", "wipe")
  vim.api.nvim_buf_set_option(buf, "buftype", "nofile")
  local content = {}
  table.insert(content, "-- Editing env " .. env_name .. " for workspace " .. wk_name)
  table.insert(content, "-- Every line that starts with -- will be ignored")
  table.insert(content, "-- env variables are in the form key=value")
  -- add instructions to content
  for k, v in pairs(env) do
    table.insert(content, k .. "=" .. v)
  end
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, content)
  -- display the buffer in a new window
  vim.api.nvim_command("vnew")
  vim.api.nvim_set_current_buf(buf)
  -- on save update the environment
  vim.api.nvim_create_autocmd("BufDelete", {
    buffer = buf,
    callback = function()
      local new_env = {}
      local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
      for _, line in ipairs(lines) do
        if line:match("^%s*%-%-") then
          goto continue
        end
        local k, v = line:match("([^=]+)=(.+)")
        new_env[k] = v
        ::continue::
      end
      on_save(new_env)
    end,
  })
end

return M
