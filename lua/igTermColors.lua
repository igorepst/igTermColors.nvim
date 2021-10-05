local itc = {}

-- bold,underline,underculr,strikethrough,reverse,italic,standout,nocombine,NONE

local colors = {
    color0 = '#000000', -- black
    color1 = '#800000', -- red
    color2 = '#008000', -- green
    color3 = '#808000', -- yellow
    color4 = '#000080', -- blue
    color5 = '#800080', -- magenta
    color6 = '#008080', -- cyan
    color7 = '#c0c0c0', -- white
    color8 = '#808080', -- bright black (gray)
    color9 = '#ff0000', -- bright red
    color10 = '#00ff00', -- bright green
    color11 = '#ffff00', --- bright yellow
    color12 = '#0000ff', -- bright blue
    color13 = '#ff00ff', -- bright magenta
    color14 = '#00ffff', -- bright cyan
    color15 = '#ffffff', -- bright white
    background = '#ffffff',
    foreground = '#000000',
    cursor = '#000000',
    selectionBackground = '#000000',
    selectionForeground = '#ffffff',
}

local higroups = function(c)
    return {
        { Normal = { fg = c.foreground, bg = c.background } },
        { Comment = { fg = c.color8, style = 'italic' } },
        { ErrorMsg = { fg = c.background, bg = c.color9 } },
        { LineNR = { fg = c.color8 } },
    }
end

function itc.getColors()
    return colors
end

local hi = function(group, color)
    if color.link then
        vim.api.nvim_command('highlight! link ' .. group .. ' ' .. color.link)
    else
        local style = color.style and 'gui=' .. color.style or 'gui=NONE'
        local fg = color.fg and 'guifg=' .. color.fg or 'guifg=NONE'
        local bg = color.bg and 'guibg=' .. color.bg or 'guibg=NONE'
        local sp = color.sp and 'guisp=' .. color.sp or 'guisp=NONE'
        vim.api.nvim_command('highlight! ' .. group .. ' ' .. style .. ' ' .. fg .. ' ' .. bg .. ' ' .. sp)
    end
end

local args = {}

function itc.setup(arguments)
    if arguments then
        args = arguments
    end
end

function itc.load()
    vim.api.nvim_command('hi clear')
    if vim.fn.exists('syntax_on') then
        vim.api.nvim_command('syntax reset')
    end

    vim.o.termguicolors = true
    vim.g.colors_name = 'igTermColors'

    if args.color_overrides then
        colors = vim.tbl_extend("force", colors, args.color_overrides)
    end

    if args.invert_for_dark and vim.opt.background:get() == 'dark' then
        colors.foreground, colors.background = colors.background, colors.foreground
        colors.selectionForeground, colors.selectionBackground = colors.selectionBackground, colors.selectionForeground
    end

    for _, hv in ipairs(higroups(colors)) do
        for k, v in pairs(hv) do
            hi(k, v)
        end
    end

    for i = 1, 15 do
        vim.g['terminal_color_' .. i] = colors['color' .. i]
    end

end

return itc
