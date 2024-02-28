return {
    "David-Kunz/gen.nvim",
    opts = {
        show_model = true,
        model = "mistral"
    },
    config = function()
        require('gen').prompts['Elaborate_Text'] = {
          prompt = "Elaborate the following text:\n$text",
          replace = true
        }
        require('gen').prompts['Fix_Code'] = {
          prompt = "Fix the following code. Only ouput the result in format ```$filetype\n...\n```:\n```$filetype\n$text\n```",
          replace = true,
          extract = "```$filetype\n(.-)```"
        }
        require('gen').prompts['Unit_Test'] = {
          prompt = "Unit test the following code. Only ouput the result in format ```$filetype\n...\n```:\n```$filetype\n$text\n```",
          replace = false,
          extract = "```$filetype\n(.-)```"
        }
    end,
}
