local u = require "gopher._utils"

return function (cmd_args)
    local parser = vim.treesitter.get_parser()
    if not parser then
        u.notify("no parser not available", "error")
        return
    end

    -- When the command is runned on the 'struct name' the current node will be
    -- the node referring directly to the 'struct name', therefore, to get the
    -- node that refers to the entire struct we have to get the parent.
    local current_node = vim.treesitter.get_node():parent()
    if not current_node then
        u.notify("no node found at cursor", "error")
        return
    end

    if current_node:type() ~= 'type_spec' then
        u.notify("not struct node under cursor","error")
        return
    end

    -- TODO: allow to pass a funcName as an argument
    -- local struct_name = (fn_args.args ~= nil and fn_args.args ~= "") and fn_args.args:gsub('"', '') or vim.treesitter.get_node_text(current_node:child(0), 1)
    local struct_name = vim.treesitter.get_node_text(current_node:child(0), 1)
    local struct_type_node = current_node:child(1):child(1)

    local args = {}
    local struct_initialization = {}
    for field in struct_type_node:iter_children() do
        if field:type() == 'field_declaration' then
            local field_type_node = field:child(1)
            local field_name_node = field:child(0)
            if field_type_node and field_name_node then
                local field_type = vim.treesitter.get_node_text(field_type_node, 1)
                local field_name = vim.treesitter.get_node_text(field_name_node, 1)
                local field_name_lower = string.lower(field_name)
                table.insert(args, field_name_lower .. " " .. field_type)
                table.insert(struct_initialization, field_name .. ": " .. field_name_lower)
            end
        end
    end

    local constructor_code = string.format(
        "\nfunc New%s(%s) *%s {\n\treturn &%s{%s}\n}\n",
        struct_name:gsub("^%l", string.upper), table.concat(args, ', '), struct_name, struct_name, table.concat(struct_initialization, ', ')
    )

    vim.fn.append(current_node:end_() + 1, vim.split(constructor_code, '\n'))
end
