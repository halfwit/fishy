addon.author  = "halfwit";
addon.name    = "fishy";
addon.version = "0.0.1";
addon.desc    = "Displays fishing profit per hour";

require("common");
local chat = require('chat');
local imgui = require('imgui');
local settings = require('settings');
local data = require('constants');
local bit = require('bit');

local default_settings = T {
    visible = T {true},
    first_attempt = 0,
    item_index = data.FishIndex,
    rewards = {},
};

local fishing = T {
    settings = settings.load(default_settings),
    pricing = T {},
    editor = T {is_open = T {false}},
    last_attempt = ashita.time.clock()['ms'],
    profit = 0,
    gil_per_hour = 0
};

local MAX_HEIGHT_IN_LINES = 12;
----------------------------------------------------------------------------------------------------
-- Helper functions borrowed from luashitacast
----------------------------------------------------------------------------------------------------
function GetTimestamp()
    local pVanaTime = ashita.memory.find('FFXiMain.dll', 0,
                                         'B0015EC390518B4C24088D4424005068', 0,
                                         0);
    local pointer = ashita.memory.read_uint32(pVanaTime + 0x34);
    local rawTime = ashita.memory.read_uint32(pointer + 0x0C) + 92514960;
    local timestamp = {};
    timestamp.day = math.floor(rawTime / 3456);
    timestamp.hour = math.floor(rawTime / 144) % 24;
    timestamp.minute = math.floor((rawTime % 144) / 2.4);
    return timestamp;
end

function GetMoon()
    local timestamp = GetTimestamp();
    local moon_index = ((timestamp.day + 26) % 84) + 1;
    local moon_table = {};
    moon_table.MoonPhase = data.MoonPhase[moon_index];
    moon_table.MoonPhasePercent = data.MoonPhasePercent[moon_index];
    return moon_table;
end

----------------------------------------------------------------------------------------------------
-- Helper functions
----------------------------------------------------------------------------------------------------
local function format_int(number)
    if (string.len(number) < 4) then return number end
    if (number ~= nil and number ~= '' and type(number) == 'number') then
        local i, j, minus, int, fraction =
            tostring(number):find('([-]?)(%d+)([.]?%d*)');

        -- we sometimes get a nil int from the above tostring, just return number in those cases
        if (int == nil) then return number end

        -- reverse the int-string and append a comma to all blocks of 3 digits
        int = int:reverse():gsub("(%d%d%d)", "%1,");

        -- reverse the int-string back remove an optional comma and put the
        -- optional minus and fractional part back
        return minus .. int:reverse():gsub("^,", "") .. fraction;
    else
        return 'NaN';
    end
end

local function split(inputstr, sep)
    if sep == nil then sep = '%s'; end
    local t = {};
    for str in string.gmatch(inputstr, '([^' .. sep .. ']+)') do
        table.insert(t, str);
    end
    return t;
end

local function update_pricing()
    local itemname;
    local itemvalue;
    for k, v in pairs(fishing.settings.item_index) do
        for k2, v2 in pairs(split(v, ':')) do
            if (k2 == 1) then itemname = v2; end
            if (k2 == 2) then itemvalue = v2; end
        end
        fishing.pricing[itemname] = itemvalue;
    end
end

----------------------------------------------------------------------------------------------------
-- Registers a callback for the commands
----------------------------------------------------------------------------------------------------
ashita.events.register('command', 'command_cb', function(e)
    -- Parse the command arguments..
    local args = e.command:args();
    if (#args == 0 or not args[1]:any('/fishy')) then return; end

    if (#args == 1 or (#args >= 2 and args[2]:any('edit'))) then
        fishing.editor.is_open[1] = not fishing.editor.is_open[1];
        return;
    end
    -- Block all related commands..
    e.blocked = true;
    if (#args == 2 and args[2]:any('clear')) then
        fishing.settings.rewards = {};
        return
    end
end);

----------------------------------------------------------------------------------------------------
-- Registers a callback for the settings
----------------------------------------------------------------------------------------------------
settings.register('settings', 'settings_update', function(s)
    if (s ~= nil) then fishing.settings = s; end

    -- Save the current settings..
    settings.save();
    --update_pricing();
end);

----------------------------------------------------------------------------------------------------
-- Load custom pricing
----------------------------------------------------------------------------------------------------
ashita.events.register('load', 'load_cb', function()
    update_pricing();
end);


----------------------------------------------------------------------------------------------------
-- Save any settings
----------------------------------------------------------------------------------------------------
ashita.events.register('unload', 'unload_cb', function()
    settings.save();
end);


----------------------------------------------------------------------------------------------------
-- Parse packets for fish and result data
----------------------------------------------------------------------------------------------------
ashita.events.register("packet_in", "packet_in_cb", function(e)
    if e.id == 39 then -- Packet 39 contains the actual fish ID. It is only sent after the fish is caught
        local player = GetPlayerEntity()
        if (player ~= nil and player.TargetIndex == struct.unpack('H', e.data_modified, 0x08 + 0x01)) then
            if (fishing.settings.first_attempt == 0) then
                fishing.settings.first_attempt = ashita.time.clock()['ms'];
            end
            local id = tostring(struct.unpack("H", e.data_modified, 17))
            local found = false;
            for key, v in pairs(data.FishIndex) do
                if string.contains(id, key) then
                    -- add to rewards
                    found = true;
                    local itemname;
                    for k2, v2 in pairs(split(v, ':')) do
                        if (k2 == 1) then itemname = v2; end
                    end
                    if (fishing.settings.rewards[itemname] == nil) then
                        fishing.settings.rewards[itemname] = 1;
                    elseif (fishing.settings.rewards[itemname] ~= nil) then
                        fishing.settings.rewards[itemname] = fishing.settings.rewards[itemname] + 1;
                    end
                end
            end
            if (found == false) then
                print('No entry found for ' .. tostring(id));
            end
        end
    end
    return false;
end);

----------------------------------------------------------------------------------------------------
-- Render config editor
----------------------------------------------------------------------------------------------------
local function render_general_config(settings)
    imgui.Text('General Settings');
    imgui.BeginChild('settings_general', {
        0, imgui.GetTextLineHeightWithSpacing() * MAX_HEIGHT_IN_LINES / 2
    }, true, ImGuiWindowFlags_AlwaysAutoResize);
    if (imgui.Checkbox('Visible', fishing.settings.visible)) then
        -- if the checkbox is interacted with, reset the last_attempt
        -- to force the window back open
        fishing.last_attempt = ashita.time.clock()['ms'];
    end
    imgui.ShowHelp('Toggles if Fishy is visible or not.');
    imgui.EndChild();
end

local function render_item_price_config(settings)
    imgui.Text('Item DB');
    imgui.BeginChild('settings_general', {
        0, imgui.GetTextLineHeightWithSpacing() * MAX_HEIGHT_IN_LINES
    }, true, ImGuiWindowFlags_AlwaysAutoResize);

    local temp_strings = T {};
    temp_strings[1] = table.concat(fishing.settings.item_index, '\n');
    if (imgui.InputTextMultiline('\nItem Prices', temp_strings, 8192, {
        0, imgui.GetTextLineHeightWithSpacing() * (MAX_HEIGHT_IN_LINES - 3)
    })) then
        fishing.settings.item_index = split(temp_strings[1], '\n');
        table.sort(fishing.settings.item_index);
    end
    imgui.ShowHelp(
        'Individual items, lowercase, separated by : with price on right side.');
    imgui.EndChild();
end

local function render_editor()
    if (not fishing.editor.is_open[1]) then return; end
    
    imgui.SetNextWindowSize({0, 0}, ImGuiCond_Always);
    if (imgui.Begin('Fishy##Config', fishing.editor.is_open,
                    ImGuiWindowFlags_AlwaysAutoResize)) then
        -- imgui.SameLine();
        if (imgui.Button('Save Settings')) then
            settings.save();
            print(
                chat.header(addon.name):append(chat.message('Settings saved.')));
        end
        imgui.SameLine();
        if (imgui.Button('Reload Settings')) then
            settings.reload();
            print(chat.header(addon.name):append(chat.message(
                                                     'Settings reloaded.')));
        end
        imgui.SameLine();
        if (imgui.Button('Reset Settings')) then
            settings.reset();
            print(chat.header(addon.name):append(chat.message(
                                                     'Settings reset to defaults.')));
        end
        if (imgui.Button('Update Pricing')) then
            update_pricing();
            print(chat.header(addon.name):append(
                      chat.message('Pricing updated.')));
        end
        if (imgui.Button('Clear Session')) then
            fishing.settings.rewards = {};
            print(chat.header(addon.name):append(
                      chat.message('Cleared session.')));
        end
        imgui.Separator();
        if (imgui.BeginTabBar('##fishy_tabbar',
                              ImGuiTabBarFlags_NoCloseWithMiddleMouseButton)) then
            if (imgui.BeginTabItem('General', nil)) then
                render_general_config(settings);
                imgui.EndTabItem();
            end
            if (imgui.BeginTabItem('Item Price', nil)) then
                render_item_price_config(settings);
                imgui.EndTabItem();
            end
            imgui.EndTabBar();
        end
    end
    imgui.End();
end

----------------------------------------------------------------------------------------------------
-- Render GUI
----------------------------------------------------------------------------------------------------
ashita.events.register("d3d_present", "present_cb", function()
    local last_attempt_secs =
        (ashita.time.clock()['ms'] - fishing.last_attempt) / 1000.0;
    render_editor();

    -- Hide the hxiclam object if not visible..
    if (not fishing.settings.visible[1]) then return; end

    imgui.SetNextWindowSize({-1, -1}, ImGuiCond_Always);
    if (imgui.Begin('fishy##Display', true,
                    bit.bor(ImGuiWindowFlags_NoDecoration,
                            ImGuiWindowFlags_AlwaysAutoResize,
                            ImGuiWindowFlags_NoFocusOnAppearing,
                            ImGuiWindowFlags_NoNav))) then

        local moon = GetMoon();
        local total_worth = 0;
        local elapsed_time = ashita.time.clock()['s'] - math.floor(fishing.settings.first_attempt / 1000.0);
        imgui.Text('Fishing session');
        imgui.Separator();
        imgui.Text('Moon: ' .. moon.MoonPhase .. ' (' .. tostring(moon.MoonPhasePercent) .. '%)');
        imgui.Separator();
        for k, v in pairs(fishing.settings.rewards) do
            local itemTotal = 0;
            if(fishing.pricing[k] ~= nil) then
                total_worth = total_worth + fishing.pricing[k] * v;
                itemTotal = v * fishing.pricing[k];
            end
            imgui.Text(k .. ': ' .. 'x' .. format_int(v) .. ' (' .. format_int(itemTotal) .. 'g)');
        end
        imgui.Text("Total Profit:");
        imgui.SameLine();
        imgui.Text(string.gsub(fishing.profit, "^(-?%d+)(%d%d%d)", "%1,%2"));
        imgui.Separator();
        if ((ashita.time.clock()['s'] % 3) == 0) then
            fishing.gil_per_hour =
            math.floor((total_worth / elapsed_time) * 3600);
        end
        imgui.Text('Total Revenue: ' .. format_int(total_worth) .. 'g' .. ' (' .. format_int(fishing.gil_per_hour) .. ' gph)');
        imgui.End();
    end
    imgui.End();
end);
