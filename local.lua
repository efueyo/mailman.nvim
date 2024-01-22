-- for local development use
-- Reload command will clear the plugin cache and reload the plugin
-- you can get the Reload command with :so %
vim.api.nvim_create_user_command('Reload', function ()
 package.loaded.mailman = nil
 package.loaded['mailman.workspace'] = nil
 package.loaded['mailman.utils'] = nil
 package.loaded['mailman.environment'] = nil
 require('mailman')
end, {})
