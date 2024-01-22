print("hola")
print("aaa")

local Workspaces = require("mailman.workspace")
local envs = require("mailman.environment")

local M = {}

-- workspace.Test()
local wks = Workspaces.list()
if vim.tbl_isempty(wks) then
	print("No workspaces")
	Workspaces.create()
end

local wk_names = {}
for n, _ in pairs(wks) do
	table.insert(wk_names, n)
end
print(vim.inspect(wk_names))
local name = vim.fn.input("\nwk name: ")
local workspace = Workspaces.get(name)

if vim.tbl_isempty(workspace.envs) then
	print("No envs")
	Workspaces.new_env(workspace.name, "dev")
end

local env_names = {}
for n, _ in pairs(workspace.envs) do
	table.insert(env_names, n)
end

print(vim.inspect(env_names))
local env_name = vim.fn.input("\nenv name: ")
local env = workspace.envs[env_name]

envs.edit(workspace.name, env_name, env, function(new_env)
	print(vim.inspect(new_env))
	Workspaces.update_env(workspace.name, env_name, new_env)
end)

return M
