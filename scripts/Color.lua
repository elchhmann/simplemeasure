
import "Luva.Engine.OOP.Ingredients.accessor"
import "Luva.Engine.OOP.class"

Color = class {
    prototype = {
        R = 0,
        G = 0,
        B = 0,
        A = 1,

        ToPrime = function (self)
            return self.R, self.G, self.B, self.A
        end
    },

    constructor = function (setPrototype, r, g, b, a)
        setPrototype {
            R = r or 0,
            G = g or 0,
            B = b or 0,
            A = a or 1
        }
    end,
}