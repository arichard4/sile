ACLOCAL_AMFLAGS = -I ../build-aux

if LINKLUA
MY_LUA_LIB=$(LUA_LIB)
UNDEFINED=-no-undefined
else
MY_LUA_LIB=
UNDEFINED=
endif

if SYSTEM_LIBTEXPDF
LIBTEXPDF_LIB=-ltexpdf
else
LIBTEXPDF_LIB=../libtexpdf/libtexpdf.la
endif

pkglib_LTLIBRARIES = justenoughharfbuzz.la justenoughlibtexpdf.la justenoughfontconfig.la fontmetrics.la svg.la
justenoughharfbuzz_la_SOURCES = justenoughharfbuzz.c
justenoughharfbuzz_la_LDFLAGS = -module -avoid-version -shared $(UNDEFINED)
justenoughharfbuzz_la_CFLAGS = $(HARFBUZZ_CFLAGS) $(FREETYPE_CFLAGS) $(LUA_INCLUDE)
justenoughharfbuzz_la_LIBADD = $(HARFBUZZ_LIBS) $(FREETYPE_LIBS) $(MY_LUA_LIB)
to_copy = .libs/justenoughharfbuzz.@SHARED_LIB_EXT@

justenoughfontconfig_la_SOURCES = justenoughfontconfig.c silewin32.h
justenoughfontconfig_la_LDFLAGS = -module -avoid-version -shared $(UNDEFINED)
justenoughfontconfig_la_CFLAGS = $(FONTCONFIG_CFLAGS) $(LUA_INCLUDE)
justenoughfontconfig_la_LIBADD = $(FONTCONFIG_LIBS) $(MY_LUA_LIB)
to_copy += .libs/justenoughfontconfig.@SHARED_LIB_EXT@

if APPKIT
pkglib_LTLIBRARIES += macfonts.la
macfonts_la_SOURCES = macfonts.m
macfonts_la_LDFLAGS = -module -avoid-version -shared $(UNDEFINED)
macfonts_la_OBJCFLAGS = -U VERSION $(FREETYPE_CFLAGS) $(LUA_INCLUDE)  -fmodules
macfonts_la_LIBADD = $(FREETYPE_LIBS) $(MY_LUA_LIB)
to_copy += .libs/macfonts.@SHARED_LIB_EXT@
endif

justenoughlibtexpdf_la_SOURCES = justenoughlibtexpdf.c imagebbox.c
justenoughlibtexpdf_la_LDFLAGS = -module -avoid-version -shared $(UNDEFINED)
justenoughlibtexpdf_la_CFLAGS = -I.. $(LIBPNG_INCLUDES) $(ZLIB_INCLUDES) $(LIBPAPER_INCLUDES) $(LUA_INCLUDE) $(FREETYPE_CFLAGS)
justenoughlibtexpdf_la_LIBADD = $(LIBTEXPDF_LIB) $(FREETYPE_LIBS) $(LIBPNG_LIBS) $(ZLIB_LIBS) $(LIBPAPER_LIBS) $(MY_LUA_LIB)
to_copy += .libs/justenoughlibtexpdf.@SHARED_LIB_EXT@

fontmetrics_la_SOURCES = fontmetrics.c
fontmetrics_la_LDFLAGS = -module -avoid-version -shared $(UNDEFINED)
fontmetrics_la_CFLAGS = $(FREETYPE_CFLAGS) $(LUA_INCLUDE) $(HARFBUZZ_CFLAGS)
fontmetrics_la_LIBADD = $(FREETYPE_LIBS) $(MY_LUA_LIB) $(HARFBUZZ_LIBS)
to_copy += .libs/fontmetrics.@SHARED_LIB_EXT@

svg_la_SOURCES = svg.c nanosvg.h
svg_la_LDFLAGS = -module -avoid-version -shared $(UNDEFINED)
svg_la_CFLAGS = $(LUA_INCLUDE)
svg_la_LIBADD = $(MY_LUA_LIB)
to_copy += .libs/svg.@SHARED_LIB_EXT@

pkglib_LTLIBRARIES += justenoughicu.la
justenoughicu_la_SOURCES = justenoughicu.c
justenoughicu_la_LDFLAGS = -module -avoid-version -shared $(UNDEFINED)
justenoughicu_la_CFLAGS = -I.. $(ICU_CFLAGS) $(LUA_INCLUDE)
justenoughicu_la_LIBADD = $(ICU_LIBS) $(MY_LUA_LIB)
to_copy += .libs/justenoughicu.@SHARED_LIB_EXT@

all-local: $(pkglib_LTLIBRARIES)
	cp $(to_copy) ../core
