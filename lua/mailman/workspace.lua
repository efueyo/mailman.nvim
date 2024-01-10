local utils = require("mailman.utils")

local function new_workspace(name)
  local wk = {
    name = name,
    environments = {},
    requests = {},
  }
  return wk
end

local data_dir = vim.fn.stdpath("data") .. "/mailman.nvim/"
local workspaces_file = data_dir .. "workspaces.json"
vim.fn.mkdir(data_dir, "p")

local all_workspaces = nil

local M = {}

function M.list()
  if all_workspaces == nil then
    local workspaces_str = utils.read_if_exists(workspaces_file)
    if workspaces_str == nil then
      all_workspaces = {}
    else
      all_workspaces = vim.fn.json_decode(workspaces_str) or {}
    end
  end
  return all_workspaces
end

function M.create()
  local name = vim.fn.input("Workspace name: ")
  local workspace = new_workspace(name)
  return workspace
end


function M._save(workspace)
  local workspaces = M.list()
  workspaces[workspace.name] = workspace
  local workspaces_str = vim.fn.json_encode(workspaces)
  utils.write_file(workspaces_file, workspaces_str)
end

function M.Test()
  local name = vim.fn.input("Workspace name: ")
  if name == "" then
    return vim.api.nvim_err_writeln("Workspace name cannot be empty")
  end
  local wk = new_workspace(name)
  M._save(wk)
  local wkspaces = M.list()
  print(vim.inspect(wkspaces))
end

return M
