return { -- Collection of various small independent plugins/modules
  'echasnovski/mini.nvim',
  config = function()
    local hipatterns = require 'mini.hipatterns'
    -- Better Around/Inside textobjects
    --
    -- Examples:
    --  - va)  - [V]isually select [A]round [)]paren
    --  - yinq - [Y]ank [I]nside [N]ext [Q]uote
    --  - ci'  - [C]hange [I]nside [']quote
    require('mini.ai').setup { n_lines = 500 }

    -- Add/delete/replace surroundings (brackets, quotes, etc.)
    --
    -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
    -- - sd'   - [S]urround [D]elete [']quotes
    -- - sr)'  - [S]urround [R]eplace [)] [']
    require('mini.surround').setup()

    -- Simple and easy statusline.
    --  You could remove this setup call if you don't like it,
    --  and try some other statusline plugin
    local statusline = require 'mini.statusline'
    -- set use_icons to true if you have a Nerd Font
    statusline.setup { use_icons = vim.g.have_nerd_font }

    -- You can configure sections in the statusline by overriding their
    -- default behavior. For example, here we set the section for
    -- cursor location to LINE:COLUMN
    ---@diagnostic disable-next-line: duplicate-set-field
    statusline.section_location = function()
      return '%2l:%-2v'
    end

    -- ... and there is more!
    --  Check out: https://github.com/echasnovski/mini.nvim
    require('mini.hipatterns').setup {

      event = 'BufReadPre',
      opts = {
        highlighters = {
          hsl_color = {
            pattern = 'hsl%(%d*%.?%d+%s*,?%s*%d*%.?%d+%%?%s*,?%s*%d*%.?%d+%%?%)',
            group = function(_, match)
              local utils = require 'custom.utils.colors'
              ---@type string, string, string
              local nh, ns, nl = match:match 'hsl%((%d*%.?%d+),?%s*(%d*%.?%d+)%%?,?%s*(%d*%.?%d+)%%?%)'
              ---@type number?, number?, number?
              local h, s, l = tonumber(nh), tonumber(ns), tonumber(nl)

              -- Check the saturation and lightness values
              if s < 0 or s > 100 or l < 0 or l > 100 then
                -- Skip this value
                return nil
              end

              local hex_color = utils.hslToHex(h, s, l)
              return hipatterns.compute_hex_color_group(hex_color, 'bg')
            end,
          },
          hsl_color_2 = {
            pattern = '%d*%.?%d+%s+,?%s*%d*%.?%d+%%%s+,?%s*%d*%.?%d+%%',
            group = function(_, match)
              local utils = require 'custom.utils.colors'
              ---@type string, string, string
              local nh, ns, nl = match:match '(%d*%.?%d+),?%s+(%d*%.?%d+)%%,?%s+(%d*%.?%d+)%%'
              ---@type number?, number?, number?
              local h, s, l = tonumber(nh), tonumber(ns), tonumber(nl)

              -- Check the saturation and lightness values
              if s < 0 or s > 100 or l < 0 or l > 100 then
                -- Skip this value
                return nil
              end

              local hex_color = utils.hslToHex(h, s, l)
              return hipatterns.compute_hex_color_group(hex_color, 'bg')
            end,
          },
          -- Highlight hex color strings (`#rrggbb`) using that color
          hex_color = hipatterns.gen_highlighter.hex_color(),
        },
      },
    }
  end,
}
