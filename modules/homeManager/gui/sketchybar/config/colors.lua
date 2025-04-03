return {
	black = 0xff181819,
	black2 = 0xff181819,
	white = 0xffe2e2e3,
	white2 = 0xffe2e2e3,
	red = 0xfff38ba8,
	red2 = 0xff860111,
	green = 0xffa6e3a1,
	green2 = 0xff013220,
	blue = 0xff89b4fa,
	blue2 = 0xff89b4fa,
	yellow = 0xfff9e2af,
	yellow2 = 0xfff9e2af,
	orange = 0xfffab387,
	orange2 = 0xfffab387,
	magenta = 0xffb4befe,
	magenta2 = 0xffb4befe,
	grey = 0xff7f8490,
	grey2 = 0xff7f8490,
	transparent = 0x00000000,

	bar = {
		bg = 0x002c2e34,
		border = 0xff2c2e34,
	},
	popup = {
		bg = 0xc02c2e34,
		border = 0xff7f8490,
	},
	bg1 = 0xff363944,
	bg2 = 0xff414550,

	with_alpha = function(color, alpha)
		if alpha > 1.0 or alpha < 0.0 then
			return color
		end
		return (color & 0x00ffffff) | (math.floor(alpha * 255.0) << 24)
	end,
}
