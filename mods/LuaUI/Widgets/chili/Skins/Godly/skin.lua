--//=============================================================================
--// Skin
--// Based on the Robocracy skin from Zero-K

local skin = {
  info = {
    name    = "Godly",
    version = "0.1",
    author  = "Kaitlin",
  }
}

--//=============================================================================
--//

skin.general = {
  --font        = "FreeSansBold.ttf",
  fontOutline = false,
  fontsize    = 13,
  textColor   = {0.83,0.8,0.52,1},
}

skin.button = {
  TileImageFG = ":cl:button.png",
  TileImageBK = ":cl:empty.png",
  tiles = {22, 22, 22, 22}, --// tile widths: left,top,right,bottom
  padding = {10, 10, 10, 10},

  DrawControl = DrawButton,
}

skin.window = {
  TileImage = ":cl:dragwindow.png",
  tiles = {62, 62, 62, 62}, --// tile widths: left,top,right,bottom
  padding = {13, 13, 13, 13},
  hitpadding = {4, 4, 4, 4},

  captionColor = {1, 1, 1, 0.45},

  boxes = {
    resize = {-21, -21, -10, -10},
    drag = {0, 0, "100%", 10},
  },

  NCHitTest = NCHitTestWithPadding,
  NCMouseDown = WindowNCMouseDown,
  NCMouseDownPostChildren = WindowNCMouseDownPostChildren,

  DrawControl = DrawWindow,
  DrawDragGrip = function() end,
  DrawResizeGrip = DrawResizeGrip,
}

skin.progressbar = {
  TileImageFG = ":cl:progressbar_full.png",
  TileImageBK = ":cl:progressbar_empty.png",
  tiles       = {10, 10, 10, 10},

  font = {
    shadow = true,
  },

  DrawControl = DrawProgressbar,
}

skin.control = skin.general
skin.dynamicprogressbar = skin.progressbar


--//=============================================================================
--//

return skin
