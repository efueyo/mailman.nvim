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

function M.get_workspaces()
  if all_workspaces == nil then
    all_workspaces = M._load_workspaces()
  end
  return all_workspaces
end

function M.create_workspace()
  local name = vim.fn.input("Workspace name: ")
  local workspace = new_workspace(name)
  return workspace
end


-- get all workspaces from the data folder
function M._load_workspaces()
  local workspaces_str = utils.read_if_exists(workspaces_file)
  if workspaces_str == nil then
    return {}
  end
  local workspaces = vim.fn.json_decode(workspaces_str) or {}
  return workspaces
end

function M._save_workspace(workspace)
  local workspaces = M._load_workspaces()
  workspaces[workspace.name] = workspace
  local workspaces_str = vim.fn.json_encode(workspaces)
  utils.write_file(workspaces_file, workspaces_str)
end

function M.Test()
  local name = vim.fn.input("Workspace name: ")
  local wk = new_workspace(name)
  M._save_workspace(wk)
  local wkspaces = M._load_workspaces()
  print(vim.inspect(wkspaces))
end

return M
