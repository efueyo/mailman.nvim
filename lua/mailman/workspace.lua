local utils = require("mailman.utils")

local function new_workspace(name)
	local wk = {
		name = name,
		envs = {},
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
	M._save(workspace)
	return workspace
end

function M.new_env(wk_name, env_name)
	local wk = M.get(wk_name)
	wk.envs[env_name] = { sample_key = "sample_value" }
	M._save(wk)
	return wk[env_name]
end

function M.get(name)
	local wk = M.list()[name]
	return wk
end

function M.update_env(workspace_name, env_name, env)
	local wk = M.get(workspace_name)
	wk.envs[env_name] = env
	M._save(wk)
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
	M.get("aaa")
end

return M
