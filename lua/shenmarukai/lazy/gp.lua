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
                --[[ChatGPT4.1]] {
                    provider = "openai",
			        name = "ChatGPT4.1",
			        chat = true,
			        command = false,
			        -- string with model name or table with model name and parameters
			        model = {
                        model = "gpt-4.1",
                        temperature = 0.0,
                        max_tokens = 32768,
                        top_p = 0
                    },
			        -- system prompt (use this to specify the persona/role of the AI)
			        system_prompt = require( "gp.defaults" ).chat_system_prompt,
		        },
		        --[[ChatGPT5]] {
		        	provider = "openai",
		        	name = "ChatGPT5",
		        	chat = true,
		        	command = false,
		        	-- string with model name or table with model name and parameters
		        	model = {
                        model = "gpt-5",
                        reasoning_effort = "high",
                        verbosity = "high",
                        summary = "detailed"
                    },
		        	-- system prompt (use this to specify the persona/role of the AI)
		        	system_prompt = require( "gp.defaults" ).code_system_prompt,
		        },
		        --[[CodeGPT4.1]] {
		        	provider = "openai",
		        	name = "CodeGPT4.1",
		        	chat = false,
		        	command = true,
		        	-- string with model name or table with model name and parameters
		        	model = {
                        model = "gpt-4.1",
                        temperature = 0.0,
                        max_tokens = 32768,
                        top_p = 0
                    },
		        	-- system prompt (use this to specify the persona/role of the AI)
		        	system_prompt = require( "gp.defaults" ).code_system_prompt,
		        },
		        --[[CodeGPT5]] {
		        	provider = "openai",
		        	name = "CodeGPT5",
		        	chat = false,
		        	command = true,
		        	-- string with model name or table with model name and parameters
		        	model = {
                        model = "gpt-5",
                        reasoning_effort = "high",
                        verbosity = "high"
                    },
		        	-- system prompt (use this to specify the persona/role of the AI)
		        	system_prompt = require( "gp.defaults" ).code_system_prompt,
		        },
	        },
        })
    end,
}
