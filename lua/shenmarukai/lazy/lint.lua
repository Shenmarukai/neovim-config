-- Lsp

return {
    {
        "williamboman/mason.nvim",
        config = true,
        priority = 1000,
    },
    {
        "mfussenegger/nvim-lint",
        dependencies = {
            "nvim-lua/plenary.nvim"
        },
        config = function()
            local lint = require("lint")

            local severities = {
              note = vim.diagnostic.severity.INFO,
              warning = vim.diagnostic.severity.WARN,
              help = vim.diagnostic.severity.HINT,
              error = vim.diagnostic.severity.ERROR, -- Add this for completeness!
            }

            local function parse(diagnostics, file_name, item)
              for _, span in ipairs(item.spans) do
                if span.file_name == file_name then
                  local message = item.message
                  if span.suggested_replacement ~= vim.NIL then
                    message = message .. "\nSuggested replacement:\n\n" .. tostring(span.suggested_replacement)
                  end

                  table.insert(diagnostics, {
                    lnum = span.line_start - 1,
                    end_lnum = span.line_end - 1,
                    col = span.column_start - 1,
                    end_col = span.column_end - 1,
                    severity = severities[item.level] or vim.diagnostic.severity.ERROR,
                    source = "clippy",
                    message = message
                  })
                end
              end

              for _, child in ipairs(item.children) do
                parse(diagnostics, file_name, child)
              end
            end

            require("lint").linters.clippy = {
              cmd = "cargo",
              args = { "clippy", "--message-format=json" },
              stdin = false,
              append_fname = false,
              ignore_exitcode = true, -- <--- This is important!
              parser = function(output, bufnr)
                local diagnostics = {}
                local items = #output > 0 and vim.split(output, "\n") or {}
                local file_name = vim.api.nvim_buf_get_name(bufnr)
                file_name = vim.fn.fnamemodify(file_name, ":.")

                for _, i in ipairs(items) do
                  local item = i ~= "" and vim.json.decode(i) or {}
                  -- cargo also outputs build artifacts messages in addition to diagnostics
                  if item and item.reason == "compiler-message" then
                    parse(diagnostics, file_name, item.message)
                  end
                end
                return diagnostics
              end,
            }

            lint.linters.cppcheck.args = {
                "--enable=warning,style,performance,information",
                function()
                    if vim.bo.filetype == "cpp" then
                        return "--language=c++"
                    else
                        return "--language=c"
                    end
                end,
                "--inline-suppr",
                "--quiet",
                function()
                    if vim.fn.isdirectory("build") == 1 then
                        return "--cppcheck-build-dir=build"
                    else
                        return nil
                    end
                end,
                function()
                    -- Add suppressions-list if .cppcheck-suppress exists
                    if vim.fn.filereadable(".cppcheck-suppress") == 1 then
                        return "--suppressions-list=.cppcheck-suppress"
                    else
                        return nil
                    end
                end,
                "--template={file}:{line}:{column}: [{id}] {severity}: {message}",
            }

            local biome = lint.linters.biomejs
            lint.linters.biomejs = function()
                biome.args = { "lint", "--reporter=github" }
                biome.parser = function(output, bufnr, linter_cwd)
                    local reporterGithubParser = require("lint.parser").from_pattern(
                        "::(.+) title=(.+),file=(.+),line=(%d+),endLine=(%d+),col=(%d+),endColumn=(%d+)::(.+)",
                        {
                            "severity",
                            "code",
                            "file",
                            "lnum",
                            "end_lnum",
                            "col",
                            "end_col",
                            "message",
                        },
                        {
                            ["error"] = vim.diagnostic.severity.ERROR,
                            ["warning"] = vim.diagnostic.severity.WARN,
                            ["notice"] = vim.diagnostic.severity.INFO,
                        },
                        { ["source"] = "biomejs" },
                        { lnum_offset = 0, end_lnum_offset = 0, end_col_offset = -1 }
                    )

                    -- when biomejs can't parse the file, the parse error does not look like the
                    -- --reporter=github format, it is still important diagnostics, especially for json
                    local parseErrorParser = function(output)
                        local diagnostics = {}

                        -- The diagnostic details we need are spread in the first 3 lines of
                        -- each error report.  These variables are declared out of the FOR
                        -- loop because we need to carry their values to parse multiple lines.
                        local fetch_message = false
                        local lnum, col, code, message

                        -- When a lnum:col:code line is detected fetch_message is set to true.
                        -- While fetch_message is true we will search for the error message.
                        -- When a error message is detected, we will create the diagnostic and
                        -- set fetch_message to false to restart the process and get the next
                        -- diagnostic.
                        for _, line in ipairs(vim.fn.split(output, "\n")) do
                            if fetch_message then
                                _, _, message = string.find(line, "%s×(.+)")

                                if message then
                                    message = (message):gsub("^%s+×%s*", "")

                                    table.insert(diagnostics, {
                                        source = "biomejs",
                                        lnum = tonumber(lnum) - 1,
                                        col = tonumber(col),
                                        message = message,
                                        code = code,
                                    })

                                    fetch_message = false
                                end
                            else
                                _, _, lnum, col, code = string.find(line, "[^:]+:(%d+):(%d+)%s([%a%/]+)")

                                if lnum then
                                    fetch_message = true
                                end
                            end
                        end

                        return diagnostics
                    end
                    local result = reporterGithubParser(output, bufnr, linter_cwd)
                    if #result ~= 0 then
                     return result
                    end

                    result = parseErrorParser(output)
                    return result
                end

                return biome
            end

            lint.linters_by_ft = {
                make = { "checkmake" },
                rust = { "clippy" },
                cpp = { --[["cpplint",]] "cppcheck" },
                c = { --[["cpplint",]] "cppcheck" },
                javascript = { "biomejs" },
                typescript = { "biomejs" },
                javascriptreact = { "biomejs" },
                typescriptreact = { "biomejs" },
            }

            vim.api.nvim_create_autocmd({ "InsertLeave", "BufReadPost", "BufNewFile" }, {
                callback = function()
                    lint.try_lint()
                end,
            })
        end,
    },
    {
        "rshkarin/mason-nvim-lint",
        dependencies = {
            "williamboman/mason.nvim",
            "mfussenegger/nvim-lint",
        },
        config = function()
            require("mason-nvim-lint").setup({
                ensure_installed = {},
                automatic_installation = false,
            })
        end,
        priority = 800,
    },
}
