

do

    ---@class MarkSetting
    ---@field public radius number
    ---@field public red number
    ---@field public green number
    ---@field public blue number
    local __markSetting = { }

    ---@class MarkBuffer
    ---@field private _Measurements table[]
    ---@field public Add fun(self: MarkBuffer, measurement: table, iterations: number, segments: table[]|nil)
    ---@field public MarkFirst fun(self: MarkBuffer)
    ---@field public MarkSettings MarkSetting
    local __markBuffer = { }

end


---@type MarkBuffer
MarkBuffer = {
    _Measurements = { },

    MarkSettings = {
        radius = 0,
        red = 0,
        green = 0,
        blue = 0,
        -- iterations = 0
    },

    Add = function (self, measurement, iterations, segments)
        measurement.iterations = iterations
        measurement.segments = segments
        table.insert(self._Measurements, measurement)   ---@diagnostic disable-line : invisible
    end,


    -- Add = function (self, segment, iterations, segments)
    --     segment.iterations = iterations
    --     segment.segments = segments
    --     table.insert(self._Measurements, segment)   ---@diagnostic disable-line : invisible
    -- end,

    MarkFirst = function (self)
        local list = self._Measurements ---@diagnostic disable-line : invisible

        if #list == 0 then
            return
        end

        local first = list[1]
        mark(
            first.pos_a, first.pos_b, first.aprim, first.bprim, first.binv, first.type,
            self.MarkSettings.red, self.MarkSettings.green, self.MarkSettings.blue,
            first.iterations, first.segments
        )
        table.remove(list, 1)
    end
}