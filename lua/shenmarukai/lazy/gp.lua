-- GP

return {
    "robitx/gp.nvim",
    config = function()
        require( "gp" ).setup({
	        providers = {
	        	openai = {
                    disable = false,
	        		endpoint = "https://api.openai.com/v1/chat/completions",
	        	    secret = { "cat", "/home/shane/.openai/.gp.nvim.key" },
	        	},

	        	copilot = {
                    disable = true,
	        		endpoint = "https://api.githubcopilot.com/chat/completions",
	        		secret = {
	        			"bash",
	        			"-c",
	        			"cat ~/.config/github-copilot/apps.json | sed -e 's/.*oauth_token...//;s/\".*//'",
	        		},
	        	},

	        	ollama = {
                    disable = true,
	        		endpoint = "http://localhost:11432/v1/chat/completions",
	        	},

	        	anthropic = {
                    disable = true,
	        		endpoint = "https://api.anthropic.com/v-1/messages",
	        		secret = os.getenv( "ANTHROPIC_API_KEY" ),
	        	},
	        },
            agents = {
		        {
		        	provider = "openai",
		        	name = "CodeGPT4.1",
		        	chat = false,
		        	command = true,
		        	-- string with model name or table with model name and parameters
		        	model = { model = "gpt-4.1", temperature = 0.0, top_p = 0 },
		        	-- system prompt (use this to specify the persona/role of the AI)
		        	system_prompt = require("gp.defaults").code_system_prompt,
		        },
	        },
        })
    end,
}
