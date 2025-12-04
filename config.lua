Config = {}

-- Global settings
Config.DefaultDisplayDistance = 10.0
Config.DefaultInteractDistance = 2.5
Config.DefaultFont = 4
Config.DefaultItemSpacing = 0.12
Config.DefaultCategorySpacing = 0.15
Config.MaxItemsPerColumn = 10

-- Available fonts:
-- 0 = Chalet London (thin)
-- 1 = House Script (handwritten)
-- 2 = Monospace
-- 4 = Chalet (default, clean)
-- 7 = Pricedown (GTA style)

-- All your menus/text displays go here
Config.Menus = {
    -- CAT CAFE MENU
    {
        name = "Cat Cafe",
        coords = vector3(-583.4, -1060.38, 21.34),
        rotation = 0.0, -- Rotation in degrees (0 = default, 90 = rotated right, etc.)
        displayDistance = 10.0,
        font = 4,
        header = {
            text = "CAT CAFE MENU",
            scale = 2.0,
            color = {255, 182, 193, 255},
            offsetZ = 1.5, -- Height above coords
        },
        columnSpacing = 1.0,
        itemSpacing = 0.12,
        categorySpacing = 0.15,
        maxItemsPerColumn = 10, -- Override global setting per menu if needed
        -- Optional interaction
        interaction = {
            enabled = false,
            distance = 2.5,
            prompt = "[E] View Full Menu",
            key = 38, -- E key (see key list below)
            event = "catcafe:openMenu", -- Event to trigger (client or server)
            eventType = "client", -- "client" or "server"
        },
        categories = {
            {
                name = "DRINKS",
                color = {173, 216, 230, 255},
                items = {
                    {name = "Boba Tea", price = "$300"},
                    {name = "Green Boba Tea", price = "$500"},
                    {name = "Pink Boba Tea", price = "$500"},
                    {name = "Blue Boba Tea", price = "$500"},
                    {name = "Orange Boba Tea", price = "$500"},
                    {name = "Mocha Meow", price = "$300"},
                    {name = "Cat Coffee", price = "$150"},
                    {name = "Neko Latte", price = "$150"},
                }
            },
            {
                name = "FOOD",
                color = {255, 218, 185, 255},
                items = {
                    {name = "Kitty Pizza", price = "$300"},
                    {name = "Bento Box", price = "$500"},
                    {name = "Purrito", price = "$500"},
                    {name = "Neko Onigiri", price = "$300"},
                    {name = "Miso Soup", price = "$500"},
                    {name = "Bowl of Ramen", price = "$350"},
                    {name = "Bowl of Noodles", price = "$200"},
                }
            },
            {
                name = "DESSERTS",
                color = {255, 192, 203, 255},
                items = {
                    {name = "Neko Cookie", price = "$300"},
                    {name = "Neko Donut", price = "$300"},
                    {name = "Strawberry Cake", price = "$400"},
                    {name = "Cat Cake Pop", price = "$400"},
                    {name = "Paw Cake", price = "$400"},
                    {name = "Blue Mochi", price = "$400"},
                    {name = "Green Mochi", price = "$400"},
                    {name = "Orange Mochi", price = "$400"},
                    {name = "Pink Mochi", price = "$400"},
                }
            }
        }
    },

    -- Pops Diner
    {
        name = "Pop's Diner",
        coords = vector3(1588.68, 6456.15, 24.91),
        rotation = 60.0, -- Rotation in degrees (0 = default, 90 = rotated right, etc.)
        displayDistance = 10.0,
        font = 4,
        header = {
            text = "POPS DINER MENU",
            scale = 2.0,
            color = {255, 182, 193, 255},
            offsetZ = 1.5, -- Height above coords
        },
        columnSpacing = 0.6,
        itemSpacing = 0.12,
        categorySpacing = 0.15,
        maxItemsPerColumn = 8, -- Food category will wrap after 8 items
        -- Optional interaction
        interaction = {
            enabled = false,
            distance = 2.5,
            prompt = "[E] View Full Menu",
            key = 38, -- E key (see key list below)
            event = "popsdiner:openMenu", -- Event to trigger (client or server)
            eventType = "client", -- "client" or "server"
        },
        categories = {
            {
                name = "FOOD",
                color = {255, 218, 185, 255},
                items = {
                    {name = "Bacon & Eggs", price = "$300"},
                    {name = "Sausage & Eggs", price = "$500"},
                    {name = "Bacon & Toast", price = "$500"},
                    {name = "BLT Sandwich", price = "$300"},
                    {name = "Ham Sandwich", price = "$500"},
                    {name = "Cheese Sandwich", price = "$350"},
                    {name = "Ham & Cheese Sandwich", price = "$200"},
                    {name = "Tuna Sandwich", price = "$200"},
                    {name = "Veggie Wrap", price = "$200"},
                    {name = "Grilled Wrap", price = "$200"},
                    {name = "Ranch Wrap", price = "$200"},
                    {name = "Cheese Burger", price = "$200"},
                    {name = "Steak Burger", price = "$200"},
                    {name = "Hamburger", price = "$200"},
                    {name = "Crisps", price = "$200"},
                }
            },
            {
                name = "DRINKS",
                color = {173, 216, 230, 255},
                items = {
                    {name = "Coffee", price = "$300"},
                    {name = "Ecola", price = "$500"},
                    {name = "Ecola Light", price = "$500"},
                    {name = "Sprunk", price = "$500"},
                    {name = "Sprunk Light", price = "$500"},
                }
            },

            {
                name = "DESSERTS",
                color = {255, 192, 203, 255},
                items = {
                    {name = "Carrot Cake", price = "$300"},
                    {name = "Cheese Cake", price = "$300"},
                    {name = "Jelly", price = "$400"},
                    {name = "Chocolate Pudding", price = "$400"},
                    {name = "Donut", price = "$400"},
                    {name = "Ice Cream", price = "$400"},
                    {name = "Chocolate Bar", price = "$400"},
                }
            }
        }
    },


    -- EXAMPLE: ROTATED MENU (facing different direction)
    -- {
    --     name = "Bar Menu",
    --     coords = vector3(200.0, -100.0, 30.0),
    --     rotation = 90.0, -- Rotated 90 degrees
    --     displayDistance = 8.0,
    --     font = 7, -- GTA Pricedown font
    --     header = {
    --         text = "BAR DRINKS",
    --         scale = 2.0,
    --         color = {255, 215, 0, 255},
    --         offsetZ = 1.2,
    --     },
    --     columnSpacing = 0.8,
    --     categories = {
    --         {
    --             name = "BEERS",
    --             color = {255, 200, 100, 255},
    --             items = {
    --                 {name = "Pisswasser", price = "$5"},
    --                 {name = "Logger", price = "$6"},
    --             }
    --         }
    --     }
    -- },
}

-- Standalone text displays (simple floating text)
Config.TextDisplays = {
    -- EXAMPLE: Multi-line sign
    -- {
    --     coords = vector3(100.0, 200.0, 30.0),
    --     rotation = 0.0,
    --     displayDistance = 15.0,
    --     font = 4,
    --     lines = {
    --         {text = "WELCOME", scale = 2.0, color = {255, 255, 255, 255}, offsetZ = 0.6},
    --         {text = "to Los Santos", scale = 1.2, color = {200, 200, 200, 255}, offsetZ = 0.3},
    --         {text = "Population: Too Many", scale = 0.8, color = {150, 150, 150, 255}, offsetZ = 0.0},
    --     },
    --     interaction = {
    --         enabled = true,
    --         distance = 3.0,
    --         prompt = "[E] Take Photo",
    --         key = 38,
    --         event = "photo:take",
    --         eventType = "client",
    --     }
    -- },

    -- EXAMPLE: Simple "Staff Only" sign
    -- {
    --     coords = vector3(50.0, 60.0, 25.0),
    --     rotation = 45.0,
    --     displayDistance = 5.0,
    --     font = 0,
    --     lines = {
    --         {text = "STAFF ONLY", scale = 1.5, color = {255, 50, 50, 255}, offsetZ = 0.0},
    --     }
    -- },
}

-- Common key codes for interaction:
-- 38 = E
-- 47 = G
-- 74 = H
-- 311 = K
-- 46 = F
-- 22 = SPACE
-- 191 = ENTER
-- Full list: https://docs.fivem.net/docs/game-references/controls/
