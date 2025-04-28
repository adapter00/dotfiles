print("Avante setting load start!")
require('avante').setup({
  provider = "claude",  -- デフォルトのAIプロバイダー
  cursor_applying_provider = 'groq', -- 差分変更はgroqで使う
  openai = {
    endpoint = "https://api.openai.com/v1",
    model = "gpt-4o",
    timeout = 30000,
    temperature = 0,
    max_tokens = 8192,
  },
  claude = {
    endpoint = "https://api.anthropic.com",
    model = "claude-3-7-sonnet-20250219",
    temperature = 0,
    max_tokens = 8192,
  },
  behaviour = {
    auto_apply_diff_after_generation = true,  -- 生成後に差分を自動適用
    enable_cursor_planning_mode = true,       -- カーソル計画モードを有効化
  },
  vendors = {
      groq = {
          __inherited_from = 'openai',
          api_key_name = 'GROQ_API_KEY',
          endpoint = 'https://api.groq.com/openai/v1/',
          model = 'llama-3.3-70b-versatile',
          max_tokens = 32768, -- remember to increase this value, otherwise it will stop generating halfway
      },
  }
})

print("Avante setting loaded!")


pcall(require, "img-clip") -- インストールチェック
local ok, img_clip = pcall(require, "img-clip")
if ok then
    require("img-clip").setup({
        default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
                insert_mode = true,
            },
            use_absolute_path = true,
        },
    })
end

require("render-markdown").setup({
  file_types = { "markdown", "Avante" },
})

