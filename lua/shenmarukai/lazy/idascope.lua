-- Idascope

return {
    "dead-null/idascope", url = "https://github.com/dead-null/idascope",

    cmd = { "IDAScope" },
    keys = {
        {
            "<leader>vv",
            function()
                require( "telescope_ida" ).IDAScope()
            end,
            desc = "Open IDAScope with Telescope",
        },
    },

    dependencies = {
        "nvim-telescope/telescope.nvim",
        "nvim-lua/plenary.nvim",
    },

    config = function()
        local ida_plugin = require( "telescope_ida" )
        local telescope = require( "telescope" )

        telescope.setup({
            defaults = {
                preview = {
                    scroll_strategy = "cycle",
                },
            },
        })

        ida_plugin.setup({
            server_url         = "http://localhost:65432/", -- XML-RPC server URL
            default_extension  = ".c", -- Default file extension for exported files
            verbose            = false, -- Enable verbose logging
            ida_plugins_dir    = "/path/to/your/IDAUSR/plugins", -- Specify the IDA Pro plugins directory
            check_if_installed = false, -- Check if the Python plugin is already installed
        })

        vim.api.nvim_create_user_command( "IDAScope", function( args )
            local xml_url = ( args.args ~= "" ) and args.args or ida_plugin.ida_xml_server
            ida_plugin.IDAScope( xml_url )
        end, {
        nargs = "?",
        desc = "IDAScope",
        })
    end,
}

