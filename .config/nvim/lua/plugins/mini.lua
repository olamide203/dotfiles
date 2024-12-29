return { -- Collection of various small independent plugins/modules
  'echasnovski/mini.nvim',
  event = 'BufReadPre',
  config = function()
    require('mini.ai').setup { n_lines = 500 }
    require('mini.surround').setup()
    local statusline = require 'mini.statusline'
    statusline.setup { use_icons = vim.g.have_nerd_font }

    ---@diagnostic disable-next-line: duplicate-set-field
    statusline.section_location = function()
      return '%2l:%-2v'
    end
    --  Check out: https://github.com/echasnovski/mini.nvim
    local hipatterns = require 'mini.hipatterns'
    hipatterns.setup {

      highlighters = {
        hsl_color = {
          pattern = 'hsl%(%d*%.?%d+%s*,?%s*%d*%.?%d+%%?%s*,?%s*%d*%.?%d+%%?%)',
          group = function(_, match)
            local utils = require 'custom.utils.colors'
            ---@type string, string, string
            local nh, ns, nl = match:match 'hsl%((%d*%.?%d+),?%s*(%d*%.?%d+)%%?,?%s*(%d*%.?%d+)%%?%)'
            ---@type number?, number?, number?
            local h, s, l = tonumber(nh), tonumber(ns), tonumber(nl)

            if not h or not s or not l then
              return nil
            end
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
            local utils = require 'utils.colors'
            ---@type string, string, string
            local nh, ns, nl = match:match '(%d*%.?%d+),?%s+(%d*%.?%d+)%%,?%s+(%d*%.?%d+)%%'
            ---@type number?, number?, number?
            local h, s, l = tonumber(nh), tonumber(ns), tonumber(nl)

            if not h or not s or not l then
              return nil
            end

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
    }
  end,
}
