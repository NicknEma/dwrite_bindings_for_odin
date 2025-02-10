package dwrite

foreign import "system:dwrite.lib"
_ :: dwrite

import "core:sys/windows"
import "vendor:directx/dxgi"

RECT     :: windows.RECT
HRESULT  :: windows.HRESULT
FILETIME :: windows.FILETIME

IUnknown        :: dxgi.IUnknown
IUnknown_VTable :: dxgi.IUnknown_VTable

GUID    :: dxgi.GUID
IID     :: dxgi.IID

FONT_FILE_TYPE :: enum i32 {
	UNKNOWN,
	CFF,
	TRUETYPE,
	OPENTYPE_COLLECTION,
	TYPE1_PFM,
	TYPE1_PFB,
	VECTOR,
	BITMAP,
	TRUETYPE_COLLECTION = OPENTYPE_COLLECTION,
}

FONT_FACE_TYPE :: enum i32 {
    CFF,
	TRUETYPE,
	OPENTYPE_COLLECTION,
	TYPE1,
	VECTOR,
	BITMAP,
	UNKNOWN,
	RAW_CFF,
	TRUETYPE_COLLECTION = OPENTYPE_COLLECTION,
}

FONT_SIMULATIONS :: enum i32 {
    NONE    = 0x0000,
	BOLD    = 0x0001,
	OBLIQUE = 0x0002
}

FONT_WEIGHT :: enum i32 {
    THIN = 100,
	EXTRA_LIGHT = 200,
	ULTRA_LIGHT = 200,
	LIGHT = 300,
	SEMI_LIGHT = 350,
	NORMAL = 400,
	REGULAR = 400,
	MEDIUM = 500,
	DEMI_BOLD = 600,
	SEMI_BOLD = 600,
	BOLD = 700,
	EXTRA_BOLD = 800,
	ULTRA_BOLD = 800,
	BLACK = 900,
	HEAVY = 900,
	EXTRA_BLACK = 950,
	ULTRA_BLACK = 950
}

FONT_STRETCH :: enum i32 {
    UNDEFINED = 0,
	ULTRA_CONDENSED = 1,
	EXTRA_CONDENSED = 2,
	CONDENSED = 3,
	SEMI_CONDENSED = 4,
	NORMAL = 5,
	MEDIUM = 5,
	SEMI_EXPANDED = 6,
	EXPANDED = 7,
	EXTRA_EXPANDED = 8,
	ULTRA_EXPANDED = 9
}

FONT_STYLE :: enum i32 {
    NORMAL,
	OBLIQUE,
	ITALIC
}

INFORMATIONAL_STRING_ID :: enum i32 {
    NONE,
	COPYRIGHT_NOTICE,
	VERSION_STRINGS,
	TRADEMARK,
	MANUFACTURER,
	DESIGNER,
	DESIGNER_URL,
	DESCRIPTION,
	FONT_VENDOR_URL,
	LICENSE_DESCRIPTION,
	LICENSE_INFO_URL,
	WIN32_FAMILY_NAMES,
	WIN32_SUBFAMILY_NAMES,
	TYPOGRAPHIC_FAMILY_NAMES,
	TYPOGRAPHIC_SUBFAMILY_NAMES,
	SAMPLE_TEXT,
	FULL_NAME,
	POSTSCRIPT_NAME,
	POSTSCRIPT_CID_NAME,
	WEIGHT_STRETCH_STYLE_FAMILY_NAME,
	DESIGN_SCRIPT_LANGUAGE_TAG,
	SUPPORTED_SCRIPT_LANGUAGE_TAG,
	PREFERRED_FAMILY_NAMES = TYPOGRAPHIC_FAMILY_NAMES,
    PREFERRED_SUBFAMILY_NAMES = TYPOGRAPHIC_SUBFAMILY_NAMES,
    WWS_FAMILY_NAME = WEIGHT_STRETCH_STYLE_FAMILY_NAME,
}

FONT_METRICS :: struct {
	designUnitsPerEm:   u16,
	ascent:    u16,
	descent:   u16,
	lineGap:   i16,
	capHeight: u16,
	xHeight:   u16,
	underlinePosition:  i16,
	underlineThickness: u16,
	strikethroughPosition:  i16,
	strikethroughThickness: u16,
}

GLYPH_METRICS :: struct {
	leftSideBearing:   i32,
	advanceWidth:      u32,
	rightSideBearing:  i32,
	topSideBearing:    i32,
	advanceHeight:     u32,
	bottomSideBearing: i32,
	verticalOriginY:   i32,
}

GLYPH_OFFSET :: struct {
	advanceOffset:  f32,
	ascenderOffset: f32,
}

FACTORY_TYPE :: enum i32 {
    SHARED,
	ISOLATED
}

MAKE_OPENTYPE_TAG :: #force_inline proc "contextless" (#any_int a, b, c, d: int) -> u32 {
	return (u32(u8(d)) << 24) | (u32(u8(c)) << 16) | (u32(u8(b)) << 8) | (u32(u8(a)))
}

MAKE_FONT_FEATURE_TAG :: #force_inline proc "contextless" (#any_int a, b, c, d: int) -> FONT_FEATURE_TAG {
	return cast(FONT_FEATURE_TAG) MAKE_OPENTYPE_TAG(a, b, c, d)
}

IFontFileLoader_UUID_STRING :: "727cad4e-d6af-4c9e-8a08-d695b11caa49"
IFontFileLoader_UUID := &IID{}
IFontFileLoader :: struct #raw_union {
    #subtype iunknown: IUnknown,
	using ifontfileloader_vtable: ^IFontFileLoader_VTable,
}
IFontFileLoader_VTable :: struct {
	using iunknown_vtable: IUnknown_VTable,
	CreateStreamFromKey: proc "system" (this: ^IFontFileLoader, fontFileReferenceKey: rawptr, fontFileReferenceKeySize: u32, fontFileStream: ^^IFontFileStream),
}

ILocalFontFileLoader_UUID_STRING :: "b2d9f3ec-c9fe-4a11-a2ec-d86208f7c0a2"
ILocalFontFileLoader_UUID := &IID{}
ILocalFontFileLoader :: struct #raw_union {
	#subtype ifontfileloader: IFontFileLoader,
	using ilocalfontfileloader_vtable: ^ILocalFontFileLoader_VTable,
};
ILocalFontFileLoader_VTable :: struct {
	using ifontfileloader_vtable: IFontFileLoader_VTable,
    GetFilePathLengthFromKey: proc "system" (this: ^ILocalFontFileLoader, fontFileReferenceKey: rawptr, fontFileReferenceKeySize: u32, filePathLength: ^u32),
	GetFilePathFromKey: proc "system" (this: ^ILocalFontFileLoader, fontFileReferenceKey: rawptr, fontFileReferenceKeySize: u32, filePath: [^]u16, filePathSize: u32),
	GetLastWriteTimeFromKey: proc "system" (this: ^ILocalFontFileLoader, fontFileReferenceKey: rawptr, fontFileReferenceKeySize: u32, lastWriteTime: ^FILETIME),
}

IFontFileStream_UUID_STRING :: "6d4865fe-0ab8-4d91-8f62-5dd6be34a3e0"
IFontFileStream_UUID := &IID{}
IFontFileStream :: struct #raw_union {
    #subtype iunknown: IUnknown,
	using ifontfilestream_vtable: ^IFontFileStream_VTable,
}
IFontFileStream_VTable :: struct {
	using iunknown_vtable: IUnknown_VTable,
    ReadFileFragment: proc "system" (this: ^IFontFileStream, fragmentStart: ^rawptr, fileOffset: u64, fragmentSize: u64, fragmentContext: ^rawptr) -> HRESULT,
	ReleaseFileFragment: proc "system" (this: ^IFontFileStream, fragmentContext: rawptr) -> HRESULT,
	GetFileSize: proc "system" (this: ^IFontFileStream, fileSize: ^u64) -> HRESULT,
	GetLastWriteTime: proc "system" (this: ^IFontFileStream, lastWriteTime: ^u64) -> HRESULT,
}

IFontFile_UUID_STRING :: "739d886a-cef5-47dc-8769-1a8b41bebbb0"
IFontFile_UUID := &IID{}
IFontFile :: struct #raw_union {
	#subtype iunknown: IUnknown,
	using ifontfile_vtable: ^IFontFile_VTable,
}
IFontFile_VTable :: struct {
	using iunknown_vtable: IUnknown_VTable,
    GetReferenceKey: proc "system" (this: ^IFontFile, fontFileReferenceKey: ^rawptr, fontFileReferenceKeySize: ^u32) -> HRESULT,
	GetLoader: proc "system" (this: ^IFontFile, fontFileLoader: ^^IFontFileLoader) -> HRESULT,
	Analyze: proc "system" (this: ^IFontFile, isSupportedFontType: ^b32, fontFileType: ^FONT_FILE_TYPE, fontFaceType: ^FONT_FACE_TYPE, numberOfFaces: ^u32) -> HRESULT,
}

PIXEL_GEOMETRY :: enum i32 {
    FLAT,
	RGB,
	BGR
}

RENDERING_MODE :: enum i32 {
    DEFAULT,
	ALIASED,
	GDI_CLASSIC,
	GDI_NATURAL,
	NATURAL,
	NATURAL_SYMMETRIC,
	OUTLINE,
	CLEARTYPE_GDI_CLASSIC         = GDI_CLASSIC,
    CLEARTYPE_GDI_NATURAL         = GDI_NATURAL,
    CLEARTYPE_NATURAL             = NATURAL,
    CLEARTYPE_NATURAL_SYMMETRIC   = NATURAL_SYMMETRIC
}

MATRIX :: struct {
	m11: f32,
	m12: f32,
	m21: f32,
	m22: f32,
	dx:  f32,
	dy:  f32,
}

IRenderingParams_UUID_STRING :: "2f0da53a-2add-47cd-82ee-d9ec34688e75"
IRenderingParams_UUID := &IID{}
IRenderingParams :: struct #raw_union {
	#subtype iunknown: IUnknown,
	using irenderingparams_vtable: ^IRenderingParams_VTable,
}
IRenderingParams_VTable :: struct {
	using iunknown_vtable: IUnknown_VTable,
    GetGamma: proc "system" (this: ^IRenderingParams) -> f32,
	GetEnhancedContrast: proc "system" (this: ^IRenderingParams) -> f32,
	GetClearTypeLevel: proc "system" (this: ^IRenderingParams) -> f32,
	GetPixelGeometry: proc "system" (this: ^IRenderingParams) -> PIXEL_GEOMETRY,
	GetRenderingMode: proc "system" (this: ^IRenderingParams) -> RENDERING_MODE,
}

// Forward declarations of D2D types
ID2D1SimplifiedGeometrySink :: struct {}
IGeometrySink :: ID2D1SimplifiedGeometrySink

IFontFace_UUID_STRING :: "5f49804d-7024-4d43-bfa9-d25984f53849"
IFontFace_UUID := &IID{}
IFontFace :: struct #raw_union {
	#subtype iunknown: IUnknown,
	using ifontface_vtable: ^IFontFace_VTable,
}
IFontFace_VTable :: struct {
	using iunknown_vtable: IUnknown_VTable,
    GetType: proc "system" (this: ^IFontFace) -> FONT_FACE_TYPE,
	GetFiles: proc "system" (this: ^IFontFace, numberOfFiles: ^u32, fontFiles: ^^IFontFile) -> HRESULT,
	GetIndex: proc "system" (this: ^IFontFace) -> u32,
	GetSimulations: proc "system" (this: ^IFontFace) -> FONT_SIMULATIONS,
	IsSymbolFont: proc "system" (this: ^IFontFace) -> b32,
	GetMetrics: proc "system" (this: ^IFontFace, fontFaceMetrics: ^FONT_METRICS),
	GetGlyphCount: proc "system" (this: ^IFontFace) -> u16,
	GetDesignGlyphMetrics: proc "system" (this: ^IFontFace, glyphIndices: [^]u16, glyphCount: u32, glyphMetrics: [^]GLYPH_METRICS, isSideways: b32 = false) -> HRESULT,
	GetGlyphIndices: proc "system" (this: ^IFontFace, codePoints: [^]u32, codePointCount: u32, glyphIndices: [^]u16) -> HRESULT,
	TryGetFontTable: proc "system" (this: ^IFontFace, openTypeTableTag: u32, tableData: ^rawptr, tableSize: ^u32, tableContext: ^rawptr, exists: ^b32) -> HRESULT,
	ReleaseFontTable: proc "system" (this: ^IFontFace, tableContext: rawptr),
	GetGlyphRunOutline: proc "system" (this: ^IFontFace, emSize: f32, glyphIndices: [^]u16, glyphAdvances: [^]f32, glyphOffsets: [^]GLYPH_OFFSET, glyphCount: u32, isSideways: b32, isRightToLeft: b32, geometrySink: ^IGeometrySink) -> HRESULT,
	GetRecommendedRenderingMode: proc "system" (this: ^IFontFace, emSize: f32, pixelsPerDip: f32, measuringMode: MEASURING_MODE, renderingParams: ^IRenderingParams, renderingMode: ^RENDERING_MODE) -> HRESULT,
	GetGdiCompatibleMetrics: proc "system" (this: ^IFontFace, emSize: f32, pixelsPerDip: f32, transform: ^MATRIX, fontFaceMetrics: ^FONT_METRICS) -> HRESULT,
	GetGdiCompatibleGlyphMetrics: proc "system" (this: ^IFontFace, emSize: f32, pixelsPerDip: f32, transform: ^MATRIX, useGdiNatural: b32, glyphIndices: [^]u16, glyphCount: u32, glyphMetrics: [^]GLYPH_METRICS, isSideways: b32 = false) -> HRESULT,
}

IFactory :: struct {}

IFontCollectionLoader_UUID_STRING :: "cca920e4-52f0-492b-bfa8-29c72ee0a468"
IFontCollectionLoader_UUID := &IID{}
IFontCollectionLoader :: struct #raw_union {
	#subtype iunknown: IUnknown,
	using ifontcollectionloader_vtable: ^IFontCollectionLoader_VTable,
}
IFontCollectionLoader_VTable :: struct {
    using iunknown_vtable: IUnknown_VTable,
	CreateEnumeratorFromKey: proc "system" (this: ^IFontCollectionLoader, factory: ^IFactory, collectionKey: rawptr, collectionKeySize: u32, fontFileEnumerator: ^^IFontFileEnumerator) -> HRESULT,
}

IFontFileEnumerator_UUID_STRING :: "72755049-5ff7-435d-8348-4be97cfa6c7c"
IFontFileEnumerator_UUID := &IID{}
IFontFileEnumerator :: struct #raw_union {
	#subtype iunknown: IUnknown,
	using ifontfileenumerator_vtable: ^IFontFileEnumerator_VTable,
}
IFontFileEnumerator_VTable :: struct {
	using iunknown_vtable: IUnknown_VTable,
	MoveNext: proc "system" (this: ^IFontFileEnumerator, hasCurrentFile: ^b32) -> HRESULT,
	GetCurrentFontFile: proc "system" (this: ^IFontFileEnumerator, fontFile: ^^IFontFile) -> HRESULT,
}

ILocalizedStrings_UUID_STRING :: "08256209-099a-4b34-b86d-c22b110e7771"
ILocalizedStrings_UUID := &IID{}
ILocalizedStrings :: struct #raw_union {
	#subtype iunknown: IUnknown,
	using ilocalizedstrings_vtable: ^ILocalizedStrings_VTable,
}
ILocalizedStrings_VTable :: struct {
	using iunknown_vtable: IUnknown_VTable,
	GetCount: proc "system" (this: ^ILocalizedStrings) -> u32,
	FindLocaleName: proc "system" (this: ^ILocalizedStrings, localeName: [^]u16, index: ^u32, exists: ^b32) -> HRESULT,
	GetLocaleNameLength: proc "system" (this: ^ILocalizedStrings, index: u32, length: ^u32) -> HRESULT,
	GetLocaleName: proc "system" (this: ^ILocalizedStrings, index: u32, localeName: [^]u16, size: u32) -> HRESULT,
	GetStringLength: proc "system" (this: ^ILocalizedStrings, index: u32, length: ^u32) -> HRESULT,
	GetString: proc "system" (this: ^ILocalizedStrings, index: u32, stringBuffer: [^]u16, size: u32) -> HRESULT,
}

IFontCollection_UUID_STRING :: "a84cee02-3eea-4eee-a827-87c1a02a0fcc"
IFontCollection_UUID := &IID{}
IFontCollection :: struct #raw_union {
	#subtype iunknown: IUnknown,
	using ifontcollection_vtable: ^IFontCollection_VTable,
}
IFontCollection_VTable :: struct {
	using iunknown_vtable: IUnknown_VTable,
	GetFontFamilyCount: proc "system" (this: ^IFontCollection) -> u32,
	GetFontFamily: proc "system" (this: ^IFontCollection, index: u32, fontFamily: ^^IFontFamily) -> HRESULT,
	FindFamilyName: proc "system" (this: ^IFontCollection, familyName: [^]u16, index: ^u32, exists: ^b32) -> HRESULT,
	GetFontFromFontFace: proc "system" (this: ^IFontCollection, fontFace: ^IFontFace, font: ^^IFont) -> HRESULT,
}

IFontList_UUID_STRING :: "1a0d8438-1d97-4ec1-aef9-a2fb86ed6acb"
IFontList_UUID := &IID{}
IFontList :: struct #raw_union {
	#subtype iunknown: IUnknown,
	using ifontlist_vtable: ^IFontList_VTable,
}
IFontList_VTable :: struct {
	using iunknown_vtable: IUnknown_VTable,
	GetFontCollection: proc "system" (this: ^IFontList, fontCollection: ^^IFontCollection) -> HRESULT,
	GetFontCount: proc "system" (this: ^IFontList) -> u32,
	GetFont: proc "system" (this: ^IFontList, index: u32, font: ^^IFont) -> HRESULT,
}

IFontFamily_UUID_STRING :: "da20d8ef-812a-4c43-9802-62ec4abd7add"
IFontFamily_UUID := &IID{}
IFontFamily :: struct #raw_union {
	#subtype ifontlist: IFontList,
	using ifontfamily_vtable: ^IFontFamily_VTable,
}
IFontFamily_VTable :: struct {
	using ifontlist_vtable: IFontList_VTable,
	GetFamilyNames: proc "system" (this: ^IFontFamily, names: ^^ILocalizedStrings) -> HRESULT,
	GetFirstMatchingFont: proc "system" (this: ^IFontFamily, weight: FONT_WEIGHT, stretch: FONT_STRETCH, style: FONT_STYLE, matchingFont: ^^IFont) -> HRESULT,
	GetMatchingFonts: proc "system" (this: ^IFontFamily, weight: FONT_WEIGHT, stretch: FONT_STRETCH, style: FONT_STYLE, matchingFonts: ^^IFontList) -> HRESULT,
}

IFont_UUID_STRING :: "acd16696-8c14-4f5d-877e-fe3fc1d32737"
IFont_UUID := &IID{}
IFont :: struct #raw_union {
	#subtype iunknown: IUnknown,
	using ifont_vtable: ^IFont_VTable,
}
IFont_VTable :: struct {
	using iunknown_vtable: IUnknown_VTable,
	GetFontFamily: proc "system" (this: ^IFont, fontFamily: ^^IFontFamily) -> HRESULT,
	GetWeight: proc "system" (this: ^IFont) -> FONT_WEIGHT,
	GetStretch: proc "system" (this: ^IFont) -> FONT_STRETCH,
	GetStyle: proc "system" (this: ^IFont) -> FONT_STYLE,
	IsSymbolFont: proc "system" (this: ^IFont) -> b32,
	GetFaceNames: proc "system" (this: ^IFont, names: ^^ILocalizedStrings) -> HRESULT,
	GetInformationalStrings: proc "system" (this: ^IFont, informationalStringID: INFORMATIONAL_STRING_ID, informationalStrings: ^^ILocalizedStrings, exists: ^b32) -> HRESULT,
	GetSimulations: proc "system" (this: ^IFont) -> FONT_SIMULATIONS,
	GetMetrics: proc "system" (this: ^IFont, fontMetrics: ^FONT_METRICS),
	HasCharacter: proc "system" (this: ^IFont, unicodeValue: u32, exists: ^b32) -> HRESULT,
	CreateFontFace: proc "system" (this: ^IFont, fontFace: ^^IFontFace) -> HRESULT,
}

READING_DIRECTION :: enum i32 {
    LEFT_TO_RIGHT = 0,
	RIGHT_TO_LEFT = 1,
	TOP_TO_BOTTOM = 2,
	BOTTOM_TO_TOP = 3,
}

FLOW_DIRECTION :: enum i32 {
    TOP_TO_BOTTOM = 0,
	BOTTOM_TO_TOP = 1,
	LEFT_TO_RIGHT = 2,
	RIGHT_TO_LEFT = 3,
}

TEXT_ALIGNMENT :: enum i32 {
    LEADING,
	TRAILING,
	CENTER,
	JUSTIFIED
}

PARAGRAPH_ALIGNMENT :: enum i32 {
    NEAR,
	FAR,
	CENTER
}

WORD_WRAPPING :: enum i32 {
    WRAP = 0,
	NO_WRAP = 1,
	EMERGENCY_BREAK = 2,
	WHOLE_WORD = 3,
	CHARACTER = 4,
}

LINE_SPACING_METHOD :: enum i32 {
    LINE_SPACING_METHOD_DEFAULT,
	LINE_SPACING_METHOD_UNIFORM,
	LINE_SPACING_METHOD_PROPORTIONAL
}

TRIMMING_GRANULARITY :: enum i32 {
    NONE,
	CHARACTER,
	WORD
}

FONT_FEATURE_TAG :: enum i32 {
    ALTERNATIVE_FRACTIONS               = ('a') | ('f' << 8) | ('r' << 16) | ('c' << 24),
    PETITE_CAPITALS_FROM_CAPITALS       = ('c') | ('2' << 8) | ('p' << 16) | ('c' << 24),
    SMALL_CAPITALS_FROM_CAPITALS        = ('c') | ('2' << 8) | ('s' << 16) | ('c' << 24),
    CONTEXTUAL_ALTERNATES               = ('c') | ('a' << 8) | ('l' << 16) | ('t' << 24),
    CASE_SENSITIVE_FORMS                = ('c') | ('a' << 8) | ('s' << 16) | ('e' << 24),
    GLYPH_COMPOSITION_DECOMPOSITION     = ('c') | ('c' << 8) | ('m' << 16) | ('p' << 24),
    CONTEXTUAL_LIGATURES                = ('c') | ('l' << 8) | ('i' << 16) | ('g' << 24),
    CAPITAL_SPACING                     = ('c') | ('p' << 8) | ('s' << 16) | ('p' << 24),
    CONTEXTUAL_SWASH                    = ('c') | ('s' << 8) | ('w' << 16) | ('h' << 24),
    CURSIVE_POSITIONING                 = ('c') | ('u' << 8) | ('r' << 16) | ('s' << 24),
    DEFAULT                             = ('d') | ('f' << 8) | ('l' << 16) | ('t' << 24),
    DISCRETIONARY_LIGATURES             = ('d') | ('l' << 8) | ('i' << 16) | ('g' << 24),
    EXPERT_FORMS                        = ('e') | ('x' << 8) | ('p' << 16) | ('t' << 24),
    FRACTIONS                           = ('f') | ('r' << 8) | ('a' << 16) | ('c' << 24),
    FULL_WIDTH                          = ('f') | ('w' << 8) | ('i' << 16) | ('d' << 24),
    HALF_FORMS                          = ('h') | ('a' << 8) | ('l' << 16) | ('f' << 24),
    HALANT_FORMS                        = ('h') | ('a' << 8) | ('l' << 16) | ('n' << 24),
    ALTERNATE_HALF_WIDTH                = ('h') | ('a' << 8) | ('l' << 16) | ('t' << 24),
    HISTORICAL_FORMS                    = ('h') | ('i' << 8) | ('s' << 16) | ('t' << 24),
    HORIZONTAL_KANA_ALTERNATES          = ('h') | ('k' << 8) | ('n' << 16) | ('a' << 24),
    HISTORICAL_LIGATURES                = ('h') | ('l' << 8) | ('i' << 16) | ('g' << 24),
    HALF_WIDTH                          = ('h') | ('w' << 8) | ('i' << 16) | ('d' << 24),
    HOJO_KANJI_FORMS                    = ('h') | ('o' << 8) | ('j' << 16) | ('o' << 24),
    JIS04_FORMS                         = ('j') | ('p' << 8) | ('0' << 16) | ('4' << 24),
    JIS78_FORMS                         = ('j') | ('p' << 8) | ('7' << 16) | ('8' << 24),
    JIS83_FORMS                         = ('j') | ('p' << 8) | ('8' << 16) | ('3' << 24),
    JIS90_FORMS                         = ('j') | ('p' << 8) | ('9' << 16) | ('0' << 24),
    KERNING                             = ('k') | ('e' << 8) | ('r' << 16) | ('n' << 24),
    STANDARD_LIGATURES                  = ('l') | ('i' << 8) | ('g' << 16) | ('a' << 24),
    LINING_FIGURES                      = ('l') | ('n' << 8) | ('u' << 16) | ('m' << 24),
    LOCALIZED_FORMS                     = ('l') | ('o' << 8) | ('c' << 16) | ('l' << 24),
    MARK_POSITIONING                    = ('m') | ('a' << 8) | ('r' << 16) | ('k' << 24),
    MATHEMATICAL_GREEK                  = ('m') | ('g' << 8) | ('r' << 16) | ('k' << 24),
    MARK_TO_MARK_POSITIONING            = ('m') | ('k' << 8) | ('m' << 16) | ('k' << 24),
    ALTERNATE_ANNOTATION_FORMS          = ('n') | ('a' << 8) | ('l' << 16) | ('t' << 24),
    NLC_KANJI_FORMS                     = ('n') | ('l' << 8) | ('c' << 16) | ('k' << 24),
    OLD_STYLE_FIGURES                   = ('o') | ('n' << 8) | ('u' << 16) | ('m' << 24),
    ORDINALS                            = ('o') | ('r' << 8) | ('d' << 16) | ('n' << 24),
    PROPORTIONAL_ALTERNATE_WIDTH        = ('p') | ('a' << 8) | ('l' << 16) | ('t' << 24),
    PETITE_CAPITALS                     = ('p') | ('c' << 8) | ('a' << 16) | ('p' << 24),
    PROPORTIONAL_FIGURES                = ('p') | ('n' << 8) | ('u' << 16) | ('m' << 24),
    PROPORTIONAL_WIDTHS                 = ('p') | ('w' << 8) | ('i' << 16) | ('d' << 24),
    QUARTER_WIDTHS                      = ('q') | ('w' << 8) | ('i' << 16) | ('d' << 24),
    REQUIRED_LIGATURES                  = ('r') | ('l' << 8) | ('i' << 16) | ('g' << 24),
    RUBY_NOTATION_FORMS                 = ('r') | ('u' << 8) | ('b' << 16) | ('y' << 24),
    STYLISTIC_ALTERNATES                = ('s') | ('a' << 8) | ('l' << 16) | ('t' << 24),
    SCIENTIFIC_INFERIORS                = ('s') | ('i' << 8) | ('n' << 16) | ('f' << 24),
    SMALL_CAPITALS                      = ('s') | ('m' << 8) | ('c' << 16) | ('p' << 24),
    SIMPLIFIED_FORMS                    = ('s') | ('m' << 8) | ('p' << 16) | ('l' << 24),
    STYLISTIC_SET_1                     = ('s') | ('s' << 8) | ('0' << 16) | ('1' << 24),
    STYLISTIC_SET_2                     = ('s') | ('s' << 8) | ('0' << 16) | ('2' << 24),
    STYLISTIC_SET_3                     = ('s') | ('s' << 8) | ('0' << 16) | ('3' << 24),
    STYLISTIC_SET_4                     = ('s') | ('s' << 8) | ('0' << 16) | ('4' << 24),
    STYLISTIC_SET_5                     = ('s') | ('s' << 8) | ('0' << 16) | ('5' << 24),
    STYLISTIC_SET_6                     = ('s') | ('s' << 8) | ('0' << 16) | ('6' << 24),
    STYLISTIC_SET_7                     = ('s') | ('s' << 8) | ('0' << 16) | ('7' << 24),
    STYLISTIC_SET_8                     = ('s') | ('s' << 8) | ('0' << 16) | ('8' << 24),
    STYLISTIC_SET_9                     = ('s') | ('s' << 8) | ('0' << 16) | ('9' << 24),
    STYLISTIC_SET_10                    = ('s') | ('s' << 8) | ('1' << 16) | ('0' << 24),
    STYLISTIC_SET_11                    = ('s') | ('s' << 8) | ('1' << 16) | ('1' << 24),
    STYLISTIC_SET_12                    = ('s') | ('s' << 8) | ('1' << 16) | ('2' << 24),
    STYLISTIC_SET_13                    = ('s') | ('s' << 8) | ('1' << 16) | ('3' << 24),
    STYLISTIC_SET_14                    = ('s') | ('s' << 8) | ('1' << 16) | ('4' << 24),
    STYLISTIC_SET_15                    = ('s') | ('s' << 8) | ('1' << 16) | ('5' << 24),
    STYLISTIC_SET_16                    = ('s') | ('s' << 8) | ('1' << 16) | ('6' << 24),
    STYLISTIC_SET_17                    = ('s') | ('s' << 8) | ('1' << 16) | ('7' << 24),
    STYLISTIC_SET_18                    = ('s') | ('s' << 8) | ('1' << 16) | ('8' << 24),
    STYLISTIC_SET_19                    = ('s') | ('s' << 8) | ('1' << 16) | ('9' << 24),
    STYLISTIC_SET_20                    = ('s') | ('s' << 8) | ('2' << 16) | ('0' << 24),
    SUBSCRIPT                           = ('s') | ('u' << 8) | ('b' << 16) | ('s' << 24),
    SUPERSCRIPT                         = ('s') | ('u' << 8) | ('p' << 16) | ('s' << 24),
    SWASH                               = ('s') | ('w' << 8) | ('s' << 16) | ('h' << 24),
    TITLING                             = ('t') | ('i' << 8) | ('t' << 16) | ('l' << 24),
    TRADITIONAL_NAME_FORMS              = ('t') | ('n' << 8) | ('a' << 16) | ('m' << 24),
    TABULAR_FIGURES                     = ('t') | ('n' << 8) | ('u' << 16) | ('m' << 24),
    TRADITIONAL_FORMS                   = ('t') | ('r' << 8) | ('a' << 16) | ('d' << 24),
    THIRD_WIDTHS                        = ('t') | ('w' << 8) | ('i' << 16) | ('d' << 24),
    UNICASE                             = ('u') | ('n' << 8) | ('i' << 16) | ('c' << 24),
    VERTICAL_WRITING                    = ('v') | ('e' << 8) | ('r' << 16) | ('t' << 24),
    VERTICAL_ALTERNATES_AND_ROTATION    = ('v') | ('r' << 8) | ('t' << 16) | ('2' << 24),
    SLASHED_ZERO                        = ('z') | ('e' << 8) | ('r' << 16) | ('o' << 24),
}

TEXT_RANGE :: struct {
	startPosition: u32,
	length: u32,
}

FONT_FEATURE :: struct {
	nameTag: FONT_FEATURE_TAG,
	parameter: u32,
}

TYPOGRAPHIC_FEATURES :: struct {
	features: [^]FONT_FEATURE,
	featureCount: u32,
}

TRIMMING :: struct {
	granularity: TRIMMING_GRANULARITY,
	delimiter: u32,
	delimiterCount: u32,
}

IInlineObject :: struct {}

ITextFormat_UUID_STRING :: "9c906818-31d7-4fd3-a151-7c5e225db55a"
ITextFormat_UUID := &IID{}
ITextFormat :: struct #raw_union {
	#subtype iunknown: IUnknown,
	using itextformat_vtable: ^ITextFormat_VTable,
}
ITextFormat_VTable :: struct {
	using iunknown_vtable: IUnknown_VTable,
    SetTextAlignment: proc "system" (this: ITextFormat, textAlignment: TEXT_ALIGNMENT) -> HRESULT,
	SetParagraphAlignment: proc "system" (this: ITextFormat, paragraphAlignment: PARAGRAPH_ALIGNMENT) -> HRESULT,
	SetWordWrapping: proc "system" (this: ITextFormat, wordWrapping: WORD_WRAPPING) -> HRESULT,
	SetReadingDirection: proc "system" (this: ITextFormat, readingDirection: READING_DIRECTION) -> HRESULT,
	SetFlowDirection: proc "system" (this: ITextFormat, flowDirection: FLOW_DIRECTION) -> HRESULT,
	SetIncrementalTabStop: proc "system" (this: ITextFormat, incrementalTabStop: f32) -> HRESULT,
	SetTrimming: proc "system" (this: ITextFormat, trimmingOptions: ^TRIMMING, trimmingSign: ^IInlineObject) -> HRESULT,
	SetLineSpacing: proc "system" (this: ITextFormat, lineSpacingMethod: LINE_SPACING_METHOD, lineSpacing: f32, baseline: f32) -> HRESULT,
	GetTextAlignment: proc "system" (this: ITextFormat) -> TEXT_ALIGNMENT,
	GetParagraphAlignment: proc "system" (this: ITextFormat) -> PARAGRAPH_ALIGNMENT,
	GetWordWrapping: proc "system" (this: ITextFormat) -> WORD_WRAPPING,
	GetReadingDirection: proc "system" (this: ITextFormat) -> READING_DIRECTION,
	GetFlowDirection: proc "system" (this: ITextFormat) -> FLOW_DIRECTION,
	GetIncrementalTabStop: proc "system" (this: ITextFormat) -> f32,
	GetTrimming: proc "system" (this: ITextFormat, trimmingOptions: ^TRIMMING, trimmingSign: ^^IInlineObject) -> HRESULT,
	GetLineSpacing: proc "system" (this: ITextFormat, lineSpacingMethod: ^LINE_SPACING_METHOD, lineSpacing: ^f32, baseline: ^f32) -> HRESULT,
	GetFontCollection: proc "system" (this: ITextFormat, fontCollection: ^^IFontCollection) -> HRESULT,
	GetFontFamilyNameLength: proc "system" (this: ITextFormat) -> u32,
	GetFontFamilyName: proc "system" (this: ITextFormat, fontFamilyName: [^]u16, nameSize: u32) -> HRESULT,
	GetFontWeight: proc "system" (this: ITextFormat) -> FONT_WEIGHT,
	GetFontStyle: proc "system" (this: ITextFormat) -> FONT_STYLE,
	GetFontStretch: proc "system" (this: ITextFormat) -> FONT_STRETCH,
	GetFontSize: proc "system" (this: ITextFormat) -> f32,
	GetLocaleNameLength: proc "system" (this: ITextFormat) -> u32,
	GetLocaleName: proc "system" (this: ITextFormat, localeName: [^]u16, nameSize: u32) -> HRESULT,
}

ITypography_UUID_STRING :: "55f1112b-1dc2-4b3c-9541-f46894ed85b6"
ITypography_UUID := &IID{}
ITypography :: struct #raw_union {
	#subtype iunknown: IUnknown,
	using itypography_vtable: ^ITypography_VTable,
}
ITypography_VTable :: struct {
	using iunknown_vtable: IUnknown_VTable,
    AddFontFeature: proc "system" (this: ^ITypography, fontFeature: FONT_FEATURE) -> HRESULT,
	GetFontFeatureCount: proc "system" (this: ^ITypography) -> u32,
	GetFontFeature: proc "system" (this: ^ITypography, fontFeatureIndex: u32, fontFeature: ^FONT_FEATURE) -> HRESULT,
}

SCRIPT_SHAPES :: enum i32 {
    DEFAULT = 0,
	NO_VISUAL = 1
}

SCRIPT_ANALYSIS :: struct {
	script: u16,
	shapes: SCRIPT_SHAPES,
}

BREAK_CONDITION :: enum i32 {
    NEUTRAL,
	CAN_BREAK,
	MAY_NOT_BREAK,
	MUST_BREAK
}

LINE_BREAKPOINT :: u8
// breakConditionBefore  : 2,
// breakConditionAfter   : 2,
// isWhitespace          : 1,
// isSoftHyphen          : 1,
// padding               : 2,

NUMBER_SUBSTITUTION_METHOD :: enum i32 {
    FROM_CULTURE,
	CONTEXTUAL,
	NONE,
	NATIONAL,
	TRADITIONAL
}

INumberSubstitution_UUID_STRING :: "14885CC9-BAB0-4f90-B6ED-5C366A2CD03D"
INumberSubstitution_UUID := &IID{}
INumberSubstitution :: struct #raw_union {
	#subtype iunknown: IUnknown,
	using inumbersubstitution_vtable: ^INumberSubstitution_VTable,
}
INumberSubstitution_VTable :: struct {
	using iunknown_vtable: IUnknown_VTable,
}

SHAPING_TEXT_PROPERTIES :: u16
// isShapedAlone        : 1,
// reserved1            : 1,
// canBreakShapingAfter : 1,
// reserved             : 13,

SHAPING_GLYPH_PROPERTIES :: u16
// justification        : 4,
// isClusterStart       : 1,
// isDiacritic          : 1,
// isZeroWidthSpace     : 1,
// reserved             : 9,

ITextAnalysisSource_UUID_STRING :: "688e1a58-5094-47c8-adc8-fbcea60ae92b"
ITextAnalysisSource_UUID := &IID{}
ITextAnalysisSource :: struct #raw_union {
	#subtype iunknown: IUnknown,
	using itextanalysissource_vtable: ^ITextAnalysisSource_VTable,
}
ITextAnalysisSource_VTable :: struct {
    using iunknown_vtable: IUnknown_VTable,
	GetTextAtPosition: proc "system" (this: ^ITextAnalysisSource, textPosition: u32, textString: ^[^]u16, textLength: ^u32) -> HRESULT,
	GetTextBeforePosition: proc "system" (this: ^ITextAnalysisSource, textPosition: u32, textString: ^[^]u16, textLength: ^u32) -> HRESULT,
	GetParagraphReadingDirection: proc "system" (this: ^ITextAnalysisSource) -> READING_DIRECTION,
	GetLocaleName: proc "system" (this: ^ITextAnalysisSource, textPosition: u32, textLength: ^u32, localeName: ^[^]u16) -> HRESULT,
	GetNumberSubstitution: proc "system" (this: ^ITextAnalysisSource, textPosition: u32, textLength: ^u32,  numberSubstitution: ^^INumberSubstitution) -> HRESULT,
}

ITextAnalysisSink_UUID_STRING :: "5810cd44-0ca0-4701-b3fa-bec5182ae4f6"
ITextAnalysisSink_UUID := &IID{}
ITextAnalysisSink :: struct #raw_union {
    #subtype iunknown: IUnknown,
	using itextanalysissink_vtable: ^ITextAnalysisSink_VTable,
}
ITextAnalysisSink_VTable :: struct {
    using iunknown_vtable: IUnknown_VTable,
	SetScriptAnalysis: proc "system" (this: ^ITextAnalysisSink, textPosition: u32, textLength: u32, scriptAnalysis: ^SCRIPT_ANALYSIS) -> HRESULT,
	SetLineBreakpoints: proc "system" (this: ^ITextAnalysisSink, textPosition: u32, textLength: u32, lineBreakpoints: ^LINE_BREAKPOINT) -> HRESULT,
	SetBidiLevel: proc "system" (this: ^ITextAnalysisSink, textPosition: u32, textLength: u32, explicitLevel: u8, resolvedLevel: u8) -> HRESULT,
	SetNumberSubstitution: proc "system" (this: ^ITextAnalysisSink, textPosition: u32, textLength: u32, numberSubstitution: ^INumberSubstitution) -> HRESULT,
}

ITextAnalyzer_UUID_STRING :: "b7e6163e-7f46-43b4-84b3-e4e6249c365d"
ITextAnalyzer_UUID := &IID{}
ITextAnalyzer :: struct #raw_union {
    #subtype iunknown: IUnknown,
	using itextanalyzer_vtable: ^ITextAnalyzer_VTable,
}
ITextAnalyzer_VTable :: struct {
    using iunknown_vtable: IUnknown_VTable,
	AnalyzeScript: proc "system" (this: ^ITextAnalyzer, analysisSource: ^ITextAnalysisSource, textPosition: u32, textLength: u32, analysisSink: ^ITextAnalysisSink) -> HRESULT,
	AnalyzeBidi: proc "system" (this: ^ITextAnalyzer, analysisSource: ^ITextAnalysisSource, textPosition: u32, textLength: u32, analysisSink: ^ITextAnalysisSink) -> HRESULT,
	AnalyzeNumberSubstitution: proc "system" (this: ^ITextAnalyzer, analysisSource: ^ITextAnalysisSource, textPosition: u32, textLength: u32, analysisSink: ^ITextAnalysisSink) -> HRESULT,
	AnalyzeLineBreakpoints: proc "system" (this: ^ITextAnalyzer, analysisSource: ^ITextAnalysisSource, textPosition: u32, textLength: u32, analysisSink: ^ITextAnalysisSink) -> HRESULT,
	
    GetGlyphs: proc "system" (this: ^ITextAnalyzer,
							  textString: [^]u16,
							  textLength: u32,
							  fontFace: ^IFontFace,
							  isSideways: b32,
							  isRightToLeft: b32,
							  scriptAnalysis: ^SCRIPT_ANALYSIS,
							  localeName: [^]u16,
							  numberSubstitution: ^INumberSubstitution,
							  features: [^]^TYPOGRAPHIC_FEATURES,
							  featureRangeLengths: [^]u32,
							  featureRanges: u32,
							  maxGlyphCount: u32,
							  clusterMap: [^]u16,
							  textProps: [^]SHAPING_TEXT_PROPERTIES,
							  glyphIndices: [^]u16,
							  glyphProps: [^]SHAPING_GLYPH_PROPERTIES,
							  actualGlyphCount: ^u32) -> HRESULT,
	
    GetGlyphPlacements: proc "system" (this: ^ITextAnalyzer,
									   textString: [^]u16,
									   clusterMap: [^]u16,
									   textProps: [^]SHAPING_TEXT_PROPERTIES,
									   textLength: u32,
									   glyphIndices: [^]u16,
									   glyphProps: [^]SHAPING_GLYPH_PROPERTIES,
									   glyphCount: u32,
									   fontFace: ^IFontFace,
									   fontEmSize: f32,
									   isSideways: b32,
									   isRightToLeft: b32,
									   scriptAnalysis: ^SCRIPT_ANALYSIS,
									   localeName: [^]u16,
									   features: [^]^TYPOGRAPHIC_FEATURES,
									   featureRangeLengths: [^]u32,
									   featureRanges: u32,
									   glyphAdvances: [^]f32,
									   glyphOffsets: [^]GLYPH_OFFSET) -> HRESULT,
	
    GetGdiCompatibleGlyphPlacements: proc "system" (this: ^ITextAnalyzer,
													textString: [^]u16,
													clusterMap: [^]u16,
													textProps: [^]SHAPING_TEXT_PROPERTIES,
													textLength: u32,
													glyphIndices: [^]u16,
													glyphProps: [^]SHAPING_GLYPH_PROPERTIES,
													glyphCount: u32,
													fontFace: ^IFontFace,
													fontEmSize: f32,
													pixelsPerDip: f32,
													transform: ^MATRIX,
													useGdiNatural: b32,
													isSideways: b32,
													isRightToLeft: b32,
													scriptAnalysis: ^SCRIPT_ANALYSIS,
													localeName: [^]u16,
													features: [^]^TYPOGRAPHIC_FEATURES,
													featureRangeLengths: [^]u32,
													featureRanges: u32,
													glyphAdvances: [^]f32,
													glyphOffsets: [^]GLYPH_OFFSET) -> HRESULT,
}

GLYPH_RUN :: struct {
	fontFace:      ^IFontFace,
	fontEmSize:    f32,
	glyphCount:    u32,
	glyphIndices:  [^]u16,
	glyphAdvances: [^]f32,
	glyphOffsets:  [^]GLYPH_OFFSET,
	isSideways:    b32,
	bidiLevel:     u32,
}

GLYPH_RUN_DESCRIPTION :: struct {
    localeName:   [^]u16,
	string:       [^]u16,
	stringLength: u32,
	clusterMap:   [^]u16,
	textPosition: u32,
}

UNDERLINE :: struct {
	width:     f32,
	thickness: f32,
	offset:    f32,
	runHeight: f32,
	readingDirection: READING_DIRECTION,
	flowDirection:    FLOW_DIRECTION,
	localeName:       [^]u16,
	measuringMode:    MEASURING_MODE,
}

STRIKETHROUGH :: struct {
	width:     f32,
	thickness: f32,
	offset:    f32,
	readingDirection: READING_DIRECTION,
	flowDirection:    FLOW_DIRECTION,
	localeName:       [^]u16,
	measuringMode:    MEASURING_MODE,
}

LINE_METRICS :: struct {
	length:    u32,
	trailingWhitespaceLength: u32,
	newlineLength: u32,
	height:    f32,
	baseline:  f32,
	isTrimmed: b32,
}

CLUSTER_METRICS :: struct {
	width:  f32,
	length: u16,
	other:  u16,
	// canWrapLineAfter : 1,
	// isWhitespace : 1,
	// isNewline : 1,
	// isSoftHyphen : 1,
	// isRightToLeft : 1,
	// padding : 11,
}

TEXT_METRICS :: struct {
	left:   f32,
	top:    f32,
	width:  f32,
	widthIncludingTrailingWhitespace: f32,
	height: f32,
	layoutWidth:  f32,
	layoutHeight: f32,
	maxBidiReorderingDepth: u32,
	lineCount:    u32,
}

INLINE_OBJECT_METRICS :: struct {
	width:    f32,
	height:   f32,
	baseline: f32,
	supportsSideways: b32,
}

OVERHANG_METRICS :: struct {
	left:   f32,
	top:    f32,
	right:  f32,
	bottom: f32,
}

HIT_TEST_METRICS :: struct {
	textPosition: u32,
	length:       u32,
	left:         f32,
	top:          f32,
	width:        f32,
	height:       f32,
	bidiLevel:    u32,
	isText:       b32,
	isTrimmed:    b32,
}

IInlineObject_UUID_STRING :: "8339FDE3-106F-47ab-8373-1C6295EB10B3"
IInlineObject_UUID := &IID{}
IInlineObject :: struct #raw_union {
	#subtype iunknown: IUnknown,
	using iinlineobject_vtable: ^IInlineObject_VTable,
}
IInlineObject_VTable :: struct {
	using iunknown_vtable: IUnknown_VTable,
	STDMETHOD(Draw)(
					_In_opt_ void* clientDrawingContext,
					_In_ ITextRenderer* renderer,
					FLOAT originX,
					FLOAT originY,
					BOOL isSideways,
					BOOL isRightToLeft,
					_In_opt_ IUnknown* clientDrawingEffect
					) PURE,
	
    STDMETHOD(GetMetrics)(
						  _Out_ INLINE_OBJECT_METRICS* metrics
						  ) PURE,
	
    STDMETHOD(GetOverhangMetrics)(
								  _Out_ OVERHANG_METRICS* overhangs
								  ) PURE,
	
    STDMETHOD(GetBreakConditions)(
								  _Out_ BREAK_CONDITION* breakConditionBefore,
								  _Out_ BREAK_CONDITION* breakConditionAfter
								  ) PURE,
}

IPixelSnapping_UUID_STRING :: "eaf3a2da-ecf4-4d24-b644-b34f6842024b"
IPixelSnapping_UUID := &IID{}
IPixelSnapping :: struct #raw_union {
    #subtype iunknown: IUnknown,
	using ipixelsnapping_vtable: ^IPixelSnapping_VTable,
}
IPixelSnapping_VTable :: struct {
	using iunknown_vtable: IUnknown_VTable,
	STDMETHOD(IsPixelSnappingDisabled)(
									   _In_opt_ void* clientDrawingContext,
									   _Out_ BOOL* isDisabled
									   ) PURE,
	
    STDMETHOD(GetCurrentTransform)(
								   _In_opt_ void* clientDrawingContext,
								   _Out_ MATRIX* transform
								   ) PURE,
	
    STDMETHOD(GetPixelsPerDip)(
							   _In_opt_ void* clientDrawingContext,
							   _Out_ FLOAT* pixelsPerDip
							   ) PURE,
}

ITextRenderer_UUID_STRING :: "ef8a8135-5cc6-45fe-8825-c5a0724eb819"
ITextRenderer_UUID := &IID{}
ITextRenderer :: struct #raw_union {
    #subtype ipixelsnapping: IPixelSnapping,
	using itextrenderer_vtable: ^ITextRenderer_VTable,
}
ITextRenderer_VTable :: struct {
	using ipixelsnapping_vtable: IPixelSnapping_VTable,
	STDMETHOD(DrawGlyphRun)(
							_In_opt_ void* clientDrawingContext,
							FLOAT baselineOriginX,
							FLOAT baselineOriginY,
							MEASURING_MODE measuringMode,
							_In_ GLYPH_RUN const* glyphRun,
							_In_ GLYPH_RUN_DESCRIPTION const* glyphRunDescription,
							_In_opt_ IUnknown* clientDrawingEffect
							) PURE,
	
    STDMETHOD(DrawUnderline)(
							 _In_opt_ void* clientDrawingContext,
							 FLOAT baselineOriginX,
							 FLOAT baselineOriginY,
							 _In_ UNDERLINE const* underline,
							 _In_opt_ IUnknown* clientDrawingEffect
							 ) PURE,
	
    STDMETHOD(DrawStrikethrough)(
								 _In_opt_ void* clientDrawingContext,
								 FLOAT baselineOriginX,
								 FLOAT baselineOriginY,
								 _In_ STRIKETHROUGH const* strikethrough,
								 _In_opt_ IUnknown* clientDrawingEffect
								 ) PURE,
	
    STDMETHOD(DrawInlineObject)(
								_In_opt_ void* clientDrawingContext,
								FLOAT originX,
								FLOAT originY,
								_In_ IInlineObject* inlineObject,
								BOOL isSideways,
								BOOL isRightToLeft,
								_In_opt_ IUnknown* clientDrawingEffect
								) PURE,
}

ITextLayout_UUID_STRING :: "53737037-6d14-410b-9bfe-0b182bb70961"
ITextLayout_UUID := &IID{}
ITextLayout :: struct #raw_union {
    #subtype itextformat: ITextFormat,
	using itextlayout_vtable: ^ITextLayout_VTable,
}
ITextLayout_VTable :: struct {
	using itextformat_vtable: ITextFormat_VTable,
	STDMETHOD(SetMaxWidth)(
						   FLOAT maxWidth
						   ) PURE,
	
    STDMETHOD(SetMaxHeight)(
							FLOAT maxHeight
							) PURE,
	
    STDMETHOD(SetFontCollection)(
								 _In_ IFontCollection* fontCollection,
								 TEXT_RANGE textRange
								 ) PURE,
	
    STDMETHOD(SetFontFamilyName)(
								 _In_z_ WCHAR const* fontFamilyName,
								 TEXT_RANGE textRange
								 ) PURE,
	
    STDMETHOD(SetFontWeight)(
							 FONT_WEIGHT fontWeight,
							 TEXT_RANGE textRange
							 ) PURE,
	
    STDMETHOD(SetFontStyle)(
							FONT_STYLE fontStyle,
							TEXT_RANGE textRange
							) PURE,
	
    STDMETHOD(SetFontStretch)(
							  FONT_STRETCH fontStretch,
							  TEXT_RANGE textRange
							  ) PURE,
	
    STDMETHOD(SetFontSize)(
						   FLOAT fontSize,
						   TEXT_RANGE textRange
						   ) PURE,
	
    STDMETHOD(SetUnderline)(
							BOOL hasUnderline,
							TEXT_RANGE textRange
							) PURE,
	
    STDMETHOD(SetStrikethrough)(
								BOOL hasStrikethrough,
								TEXT_RANGE textRange
								) PURE,
	
    STDMETHOD(SetDrawingEffect)(
								IUnknown* drawingEffect,
								TEXT_RANGE textRange
								) PURE,
	
    STDMETHOD(SetInlineObject)(
							   _In_ IInlineObject* inlineObject,
							   TEXT_RANGE textRange
							   ) PURE,
	
    STDMETHOD(SetTypography)(
							 _In_ ITypography* typography,
							 TEXT_RANGE textRange
							 ) PURE,
	
    STDMETHOD(SetLocaleName)(
							 _In_z_ WCHAR const* localeName,
							 TEXT_RANGE textRange
							 ) PURE,
	
    STDMETHOD_(FLOAT, GetMaxWidth)() PURE,
	
    STDMETHOD_(FLOAT, GetMaxHeight)() PURE,
	
    STDMETHOD(GetFontCollection)(
								 UINT32 currentPosition,
								 _COM_Outptr_ IFontCollection** fontCollection,
								 _Out_opt_ TEXT_RANGE* textRange = NULL
								 ) PURE,
	
    STDMETHOD(GetFontFamilyNameLength)(
									   UINT32 currentPosition,
									   _Out_ UINT32* nameLength,
									   _Out_opt_ TEXT_RANGE* textRange = NULL
									   ) PURE,
	
    STDMETHOD(GetFontFamilyName)(
								 UINT32 currentPosition,
								 _Out_writes_z_(nameSize) WCHAR* fontFamilyName,
								 UINT32 nameSize,
								 _Out_opt_ TEXT_RANGE* textRange = NULL
								 ) PURE,
	
    STDMETHOD(GetFontWeight)(
							 UINT32 currentPosition,
							 _Out_ FONT_WEIGHT* fontWeight,
							 _Out_opt_ TEXT_RANGE* textRange = NULL
							 ) PURE,
	
    STDMETHOD(GetFontStyle)(
							UINT32 currentPosition,
							_Out_ FONT_STYLE* fontStyle,
							_Out_opt_ TEXT_RANGE* textRange = NULL
							) PURE,
	
    STDMETHOD(GetFontStretch)(
							  UINT32 currentPosition,
							  _Out_ FONT_STRETCH* fontStretch,
							  _Out_opt_ TEXT_RANGE* textRange = NULL
							  ) PURE,
	
    STDMETHOD(GetFontSize)(
						   UINT32 currentPosition,
						   _Out_ FLOAT* fontSize,
						   _Out_opt_ TEXT_RANGE* textRange = NULL
						   ) PURE,
	
    STDMETHOD(GetUnderline)(
							UINT32 currentPosition,
							_Out_ BOOL* hasUnderline,
							_Out_opt_ TEXT_RANGE* textRange = NULL
							) PURE,
	
    STDMETHOD(GetStrikethrough)(
								UINT32 currentPosition,
								_Out_ BOOL* hasStrikethrough,
								_Out_opt_ TEXT_RANGE* textRange = NULL
								) PURE,
	
    STDMETHOD(GetDrawingEffect)(
								UINT32 currentPosition,
								_COM_Outptr_ IUnknown** drawingEffect,
								_Out_opt_ TEXT_RANGE* textRange = NULL
								) PURE,
	
    STDMETHOD(GetInlineObject)(
							   UINT32 currentPosition,
							   _COM_Outptr_ IInlineObject** inlineObject,
							   _Out_opt_ TEXT_RANGE* textRange = NULL
							   ) PURE,
	
    STDMETHOD(GetTypography)(
							 UINT32 currentPosition,
							 _COM_Outptr_ ITypography** typography,
							 _Out_opt_ TEXT_RANGE* textRange = NULL
							 ) PURE,
	
    STDMETHOD(GetLocaleNameLength)(
								   UINT32 currentPosition,
								   _Out_ UINT32* nameLength,
								   _Out_opt_ TEXT_RANGE* textRange = NULL
								   ) PURE,
	
    STDMETHOD(GetLocaleName)(
							 UINT32 currentPosition,
							 _Out_writes_z_(nameSize) WCHAR* localeName,
							 UINT32 nameSize,
							 _Out_opt_ TEXT_RANGE* textRange = NULL
							 ) PURE,
	
    STDMETHOD(Draw)(
					_In_opt_ void* clientDrawingContext,
					_In_ ITextRenderer* renderer,
					FLOAT originX,
					FLOAT originY
					) PURE,
	
    STDMETHOD(GetLineMetrics)(
							  _Out_writes_opt_(maxLineCount) LINE_METRICS* lineMetrics,
							  UINT32 maxLineCount,
							  _Out_ UINT32* actualLineCount
							  ) PURE,
	
    STDMETHOD(GetMetrics)(
						  _Out_ TEXT_METRICS* textMetrics
						  ) PURE,
	
    STDMETHOD(GetOverhangMetrics)(
								  _Out_ OVERHANG_METRICS* overhangs
								  ) PURE,
	
    STDMETHOD(GetClusterMetrics)(
								 _Out_writes_opt_(maxClusterCount) CLUSTER_METRICS* clusterMetrics,
								 UINT32 maxClusterCount,
								 _Out_ UINT32* actualClusterCount
								 ) PURE,
	
    STDMETHOD(DetermineMinWidth)(
								 _Out_ FLOAT* minWidth
								 ) PURE,
	
    STDMETHOD(HitTestPoint)(
							FLOAT pointX,
							FLOAT pointY,
							_Out_ BOOL* isTrailingHit,
							_Out_ BOOL* isInside,
							_Out_ HIT_TEST_METRICS* hitTestMetrics
							) PURE,
	
    STDMETHOD(HitTestTextPosition)(
								   UINT32 textPosition,
								   BOOL isTrailingHit,
								   _Out_ FLOAT* pointX,
								   _Out_ FLOAT* pointY,
								   _Out_ HIT_TEST_METRICS* hitTestMetrics
								   ) PURE,
	
    STDMETHOD(HitTestTextRange)(
								UINT32 textPosition,
								UINT32 textLength,
								FLOAT originX,
								FLOAT originY,
								_Out_writes_opt_(maxHitTestMetricsCount) HIT_TEST_METRICS* hitTestMetrics,
								UINT32 maxHitTestMetricsCount,
								_Out_ UINT32* actualHitTestMetricsCount
								) PURE,
	
    using ITextFormat::GetFontCollection,
    using ITextFormat::GetFontFamilyNameLength,
    using ITextFormat::GetFontFamilyName,
    using ITextFormat::GetFontWeight,
    using ITextFormat::GetFontStyle,
    using ITextFormat::GetFontStretch,
    using ITextFormat::GetFontSize,
    using ITextFormat::GetLocaleNameLength,
    using ITextFormat::GetLocaleName,
}


IBitmapRenderTarget_UUID_STRING :: "5e5a32a3-8dff-4773-9ff6-0696eab77267"
IBitmapRenderTarget_UUID := &IID{}
IBitmapRenderTarget :: struct #raw_union {
    #subtype iunknown: IUnknown,
	using ibitmaprendertarget_vtable: ^IBitmapRenderTarget_VTable,
}
IBitmapRenderTarget_VTable :: struct {
	using iunknown_vtable: IUnknown_VTable,
	STDMETHOD(DrawGlyphRun)(
							FLOAT baselineOriginX,
							FLOAT baselineOriginY,
							MEASURING_MODE measuringMode,
							_In_ GLYPH_RUN const* glyphRun,
							_In_ IRenderingParams* renderingParams,
							COLORREF textColor,
							_Out_opt_ RECT* blackBoxRect = NULL
							) PURE,
	
    STDMETHOD_(HDC, GetMemoryDC)() PURE,
	
    STDMETHOD_(FLOAT, GetPixelsPerDip)() PURE,
	
    STDMETHOD(SetPixelsPerDip)(
							   FLOAT pixelsPerDip
							   ) PURE,
	
    STDMETHOD(GetCurrentTransform)(
								   _Out_ MATRIX* transform
								   ) PURE,
	
    STDMETHOD(SetCurrentTransform)(
								   _In_opt_ MATRIX const* transform
								   ) PURE,
	
    STDMETHOD(GetSize)(
					   _Out_ SIZE* size
					   ) PURE,
	
    STDMETHOD(Resize)(
					  UINT32 width,
					  UINT32 height
					  ) PURE,
}

IGdiInterop_UUID_STRING :: "1edd9491-9853-4299-898f-6432983b6f3a"
IGdiInterop_UUID := &IID{}
IGdiInterop :: struct #raw_union {
    #subtype iunknown: IUnknown,
	using igdiinterop_vtable: ^IGdiInterop_VTable,
}
IGdiInterop_VTable :: struct {
	using iunknown_vtable: IUnknown_VTable,
	STDMETHOD(CreateFontFromLOGFONT)(
									 _In_ LOGFONTW const* logFont,
									 _COM_Outptr_ IFont** font
									 ) PURE,
	
    STDMETHOD(ConvertFontToLOGFONT)(
									_In_ IFont* font,
									_Out_ LOGFONTW* logFont,
									_Out_ BOOL* isSystemFont
									) PURE,
	
    STDMETHOD(ConvertFontFaceToLOGFONT)(
										_In_ IFontFace* font,
										_Out_ LOGFONTW* logFont
										) PURE,
	
    STDMETHOD(CreateFontFaceFromHdc)(
									 HDC hdc,
									 _COM_Outptr_ IFontFace** fontFace
									 ) PURE,
	
    STDMETHOD(CreateBitmapRenderTarget)(
										_In_opt_ HDC hdc,
										UINT32 width,
										UINT32 height,
										_COM_Outptr_ IBitmapRenderTarget** renderTarget
										) PURE,
}

TEXTURE_TYPE :: enum {
    ALIASED_1x1,
	CLEARTYPE_3x1
}

ALPHA_MAX :: 255

IGlyphRunAnalysis_UUID_STRING :: "7d97dbf7-e085-42d4-81e3-6a883bded118"
IGlyphRunAnalysis_UUID := &IID{}
IGlyphRunAnalysis :: struct #raw_union {
    #subtype iunknown: IUnknown,
	using iglyphrunanalysis_vtable: ^IGlyphRunAnalysis_VTable,
}
IGlyphRunAnalysis_VTable :: struct {
	using iunknown_vtable: IUnknown_VTable,
	GetAlphaTextureBounds: proc "system" (this: ^IGlyphRunAnalysis, textureType: TEXTURE_TYPE, textureBounds: ^RECT) -> HRESULT,
	CreateAlphaTexture: proc "system" (this: ^IGlyphRunAnalysis, textureType: TEXTURE_TYPE, textureBounds: ^RECT, alphaValues: [^]byte, bufferSize: u32) -> HRESULT,
	GetAlphaBlendParams: proc "system" (this: ^IGlyphRunAnalysis, renderingParams: ^IRenderingParams, blendGamma: ^f32, blendEnhancedContrast: ^f32, blendClearTypeLevel: ^f32) -> HRESULT,
}

IFactory_UUID_STRING :: "b859ee5a-d838-4b5b-a2e8-1adc7d93db48"
IFactory_UUID := &IID{}
IFactory :: struct #raw_union {
    #subtype iunknown: IUnknown,
	using ifactory_vtable: ^IFactory_VTable,
}
IFactory_VTable :: struct {
	using iunknown_vtable: IUnknown_VTable,
	STDMETHOD(GetSystemFontCollection)(
									   _COM_Outptr_ IFontCollection** fontCollection,
									   BOOL checkForUpdates = FALSE
									   ) PURE,
	
    STDMETHOD(CreateCustomFontCollection)(
										  _In_ IFontCollectionLoader* collectionLoader,
										  _In_reads_bytes_(collectionKeySize) void const* collectionKey,
										  UINT32 collectionKeySize,
										  _COM_Outptr_ IFontCollection** fontCollection
										  ) PURE,
	
    STDMETHOD(RegisterFontCollectionLoader)(
											_In_ IFontCollectionLoader* fontCollectionLoader
											) PURE,
	
    STDMETHOD(UnregisterFontCollectionLoader)(
											  _In_ IFontCollectionLoader* fontCollectionLoader
											  ) PURE,
	
    STDMETHOD(CreateFontFileReference)(
									   _In_z_ WCHAR const* filePath,
									   _In_opt_ FILETIME const* lastWriteTime,
									   _COM_Outptr_ IFontFile** fontFile
									   ) PURE,
	
    STDMETHOD(CreateCustomFontFileReference)(
											 _In_reads_bytes_(fontFileReferenceKeySize) void const* fontFileReferenceKey,
											 UINT32 fontFileReferenceKeySize,
											 _In_ IFontFileLoader* fontFileLoader,
											 _COM_Outptr_ IFontFile** fontFile
											 ) PURE,
	
    STDMETHOD(CreateFontFace)(
							  FONT_FACE_TYPE fontFaceType,
							  UINT32 numberOfFiles,
							  _In_reads_(numberOfFiles) IFontFile* const* fontFiles,
							  UINT32 faceIndex,
							  FONT_SIMULATIONS fontFaceSimulationFlags,
							  _COM_Outptr_ IFontFace** fontFace
							  ) PURE,
	
    STDMETHOD(CreateRenderingParams)(
									 _COM_Outptr_ IRenderingParams** renderingParams
									 ) PURE,
	
    STDMETHOD(CreateMonitorRenderingParams)(
											HMONITOR monitor,
											_COM_Outptr_ IRenderingParams** renderingParams
											) PURE,
	
    STDMETHOD(CreateCustomRenderingParams)(
										   FLOAT gamma,
										   FLOAT enhancedContrast,
										   FLOAT clearTypeLevel,
										   PIXEL_GEOMETRY pixelGeometry,
										   RENDERING_MODE renderingMode,
										   _COM_Outptr_ IRenderingParams** renderingParams
										   ) PURE,
	
    STDMETHOD(RegisterFontFileLoader)(
									  _In_ IFontFileLoader* fontFileLoader
									  ) PURE,
	
    STDMETHOD(UnregisterFontFileLoader)(
										_In_ IFontFileLoader* fontFileLoader
										) PURE,
	
    STDMETHOD(CreateTextFormat)(
								_In_z_ WCHAR const* fontFamilyName,
								_In_opt_ IFontCollection* fontCollection,
								FONT_WEIGHT fontWeight,
								FONT_STYLE fontStyle,
								FONT_STRETCH fontStretch,
								FLOAT fontSize,
								_In_z_ WCHAR const* localeName,
								_COM_Outptr_ ITextFormat** textFormat
								) PURE,
	
    STDMETHOD(CreateTypography)(
								_COM_Outptr_ ITypography** typography
								) PURE,
	
    STDMETHOD(GetGdiInterop)(
							 _COM_Outptr_ IGdiInterop** gdiInterop
							 ) PURE,
	
    STDMETHOD(CreateTextLayout)(
								_In_reads_(stringLength) WCHAR const* string,
								UINT32 stringLength,
								_In_ ITextFormat* textFormat,
								FLOAT maxWidth,
								FLOAT maxHeight,
								_COM_Outptr_ ITextLayout** textLayout
								) PURE,
	
    STDMETHOD(CreateGdiCompatibleTextLayout)(
											 _In_reads_(stringLength) WCHAR const* string,
											 UINT32 stringLength,
											 _In_ ITextFormat* textFormat,
											 FLOAT layoutWidth,
											 FLOAT layoutHeight,
											 FLOAT pixelsPerDip,
											 _In_opt_ MATRIX const* transform,
											 BOOL useGdiNatural,
											 _COM_Outptr_ ITextLayout** textLayout
											 ) PURE,
	
    STDMETHOD(CreateEllipsisTrimmingSign)(
										  _In_ ITextFormat* textFormat,
										  _COM_Outptr_ IInlineObject** trimmingSign
										  ) PURE,
	
    STDMETHOD(CreateTextAnalyzer)(
								  _COM_Outptr_ ITextAnalyzer** textAnalyzer
								  ) PURE,
	
    STDMETHOD(CreateNumberSubstitution)(
										_In_ NUMBER_SUBSTITUTION_METHOD substitutionMethod,
										_In_z_ WCHAR const* localeName,
										_In_ BOOL ignoreUserOverride,
										_COM_Outptr_ INumberSubstitution** numberSubstitution
										) PURE,
	
    STDMETHOD(CreateGlyphRunAnalysis)(
									  _In_ GLYPH_RUN const* glyphRun,
									  FLOAT pixelsPerDip,
									  _In_opt_ MATRIX const* transform,
									  RENDERING_MODE renderingMode,
									  MEASURING_MODE measuringMode,
									  FLOAT baselineOriginX,
									  FLOAT baselineOriginY,
									  _COM_Outptr_ IGlyphRunAnalysis** glyphRunAnalysis
									  ) PURE,
	
}


@(default_calling_convention="system", link_prefix="DWrite")
foreign dwrite {
	CreateFactory(factoryType: FACTORY_TYPE, iid: REFIID, factory: ^^IUnknown) -> HRESULT ---
}


FACILITY_DWRITE :: 0x898
DWRITE_ERR_BASE :: 0x5000

MAKE_DWRITE_HR :: #force_inline proc "contextless" (severity: u32, code: u32) {
	return windows.MAKE_HRESULT(severity, FACILITY_DWRITE, DWRITE_ERR_BASE + code)
}

MAKE_DWRITE_HR_ERR :: #force_inline proc "contextless" (code: u32) {
	return MAKE_DWRITE_HR(SEVERITY_ERROR, code)
}
