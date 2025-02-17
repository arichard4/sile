SILE.require("packages/rebox")
SILE.require("packages/raiselower")

local shapeHbox = function (options, content)
  -- Clear irrelevant values before passing to font
  options.lines, options.join, options.raise, options.shift, options.color, options.scale = nil, nil, nil, nil, nil, nil
  SILE.call("noindent")
  local hbox = SILE.call("hbox", {}, function ()
    SILE.call("font", options, content)
  end)
  table.remove(SILE.typesetter.state.nodes)
  return hbox
end

-- This implementation relies on the hangafter and hangindent features of Knuth's line-breaking algorithm.
-- These features in core line breaking algorithm supply the blank space in the paragraph shape but don't fill it with anything.
SILE.registerCommand("dropcap", function (options, content)
  local lines = SU.cast("integer", options.lines or 3)
  local join = SU.boolean(options.join, false)
  local standoff = SU.cast("measurement", options.standoff or "1spc")
  local raise = SU.cast("measurement", options.raise or 0)
  local shift = SU.cast("measurement", options.shift or 0)
  local size = SU.cast("measurement or nil", options.size or nil)
  local scale = SU.cast("number", options.scale or 1.0)
  local color = options.color
  options.size = nil -- we need to measure the "would have been" size before using this

  if color then SILE.require("packages/color") end

  -- We want the drop cap to span over N lines, that is N - 1 baselineskip + the height of the first line.
  -- Note this only works for the default linespace mechanism.
  -- We determine the height of the first line by measuring the size the initial content *would have* been.
  -- This gives the font some control over its relative size, sometimes desired sometimes undesired.
  local tmpHbox = shapeHbox(options, content)
  local extraHeight = SILE.measurement((lines - 1).."bs"):tonumber()
  local targetHeight = tmpHbox.height:tonumber() * scale + extraHeight
  SU.debug("dropcaps", "Target height", targetHeight)

  -- Now we need to figure out how to scale the dropcap font to get an initial of targetHeight.
  -- From that we can also figure out the width it will be at that height.
  local curSize = SILE.measurement(SILE.settings.get("font.size")):tonumber()
  local curHeight, curWidth = tmpHbox.height:tonumber(), tmpHbox.width:tonumber()
  options.size = size and size:tonumber() or (targetHeight / curHeight * curSize)
  local targetWidth = curWidth / curSize * options.size
  SU.debug("dropcaps", "Target font size", options.size)
  SU.debug("dropcaps", "Target width", targetWidth)

  -- Typeset the dropcap with its final shape, but don't output it yet
  local hbox = shapeHbox(options, content)

  -- Setup up the necessary indents for the final paragraph content
  local joinOffset = join and standoff:tonumber() or 0
  SILE.settings.set("current.hangAfter", -lines)
  SILE.settings.set("current.hangIndent", targetWidth + joinOffset)
  SU.debug("dropcaps", "joinOffset", joinOffset)

  -- The paragraph is indented so as to leave enough space for the drop cap.
  -- We "trick" the typesetter with a zero-dimension box wrapping our original box.
  SILE.call("rebox", { height = 0, width = -joinOffset }, function ()
    SILE.call("glue", { width = shift - targetWidth - joinOffset })
    SILE.call("lower", { height = extraHeight - raise }, function ()
      SILE.call(color and "color" or "noop", { color = color }, function ()
        SILE.typesetter:pushHbox(hbox)
      end)
    end)
  end)
end, "Show an 'initial capital' (also known as a 'drop cap') at the start of the content paragraph.")

return {
  documentation = [[
\begin{document}
The \code{dropcaps} package allows you to format paragraphs with an 'initial capital' (also commonly
referred as a 'drop cap'), typically one large capital letter used as a decorative element at the beginning of a paragraph.

It provides the \code{\\dropcap} command.
The content passed will be the initial character(s).
The primary option is \code{lines}, an integer specifying the number of lines to span (defaults to 3).
The scale of can be adjusted relative to the first line using the \code{scale} option (defaults to 1.0).
The \code{join} is a boolean for whether to join the dropcap to the first line (defaults to false).
If \code{join} is true, the value of the \code{standoff} option (defaults to 1spc) is applied to all but the first line.
Optionally \code{color} can be passed to change the typeface color, sometimes useful to offset the apparent weight of a large glyph.
To tweak the position of the dropcap, measurements may be passed to the \code{raise} and \code{shift} options.
Other options passed to \\dropcap will be passed through to \\font when drawing the initial letter(s).
This may be useful for passing OpenType options or other font preferences.

\begin{note}
One caveat is that the size of the initials is calculated using the default linespacing mechanism.
If you are using an alternative method from the linespacing package, you might see strange results.
Set the \code{document.baselineskip} to approximate your effective leading value for best results.
If that doesn't work set the size manually.
Using \code{SILE.setCommandDefaults()} can be helpful for so you don't have to set the size every time.
\end{note}
\end{document}
]] }
