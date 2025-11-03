return {
    {
        'echasnovski/mini.surround',
        version = false,
        config = function ()
            require('mini.surround').setup {
                -- Custom settings can be added here
                -- For example, to change the default pairs:
                -- custom_surroundings = {
                --     ['('] = { input = '(', output = ')' },
                --     ['{'] = { input = '{', output = '}' },
                -- }
            }
        end
    }
}
