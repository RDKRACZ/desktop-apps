#ifndef CTHEMES_H
#define CTHEMES_H

#include <QColor>

#ifdef Q_OS_WIN
# include <windows.h>
#endif

namespace NSThemeLight {
    static const std::wstring theme_id = L"theme-light";

    static const std::wstring color_brand_word = L"#446995";
    static const std::wstring color_brand_slide = L"#aa5252";
    static const std::wstring color_brand_cell = L"#40865c";

    static const std::wstring color_window_background = L"#f1f1f1";
    static const std::wstring color_window_border = L"#888";

    static const std::wstring color_text_normal = L"#444";
    static const std::wstring color_text_normal_pressed = L"#fff";

    static const std::wstring color_tab_active_background = L"#fff";
    static const std::wstring color_tab_simple_active_background = L"#fff";
    static const std::wstring color_tab_simple_active_text = L"#444";
    static const std::wstring color_tab_default_active_background = L"#fff";
    static const std::wstring color_tab_default_active_text = L"#444";
    static const std::wstring color_tab_divider = L"#a5a5a5";

    static const QColor button_normal_opacity = QColor(255,255,255,255);
    static const std::wstring color_logo = L"dark";
}

namespace NSThemeClassicLight {
    static const std::wstring theme_id = L"theme-classic-light";

    static const std::wstring color_brand_word = L"#446995";
    static const std::wstring color_brand_slide = L"#aa5252";
    static const std::wstring color_brand_cell = L"#40865c";

    static const std::wstring color_window_background = L"#f1f1f1";
    static const std::wstring color_window_border = L"#888";

    static const std::wstring color_text_normal = L"#444";
    static const std::wstring color_text_normal_pressed = L"#fff";

    static const std::wstring color_tab_active_background = L"#fff";
    static const std::wstring color_tab_simple_active_background = L"#fff";
    static const std::wstring color_tab_simple_active_text = L"#444";
    static const std::wstring color_tab_default_active_background = L"#fff";
    static const std::wstring color_tab_default_active_text = L"#444";
    static const std::wstring color_tab_divider = L"#a5a5a5";

    static const QColor button_normal_opacity = QColor(255,255,255,255);
    static const std::wstring color_logo = L"dark";
}

namespace NSThemeDark {
    static const std::wstring theme_id = L"theme-dark";

    static const std::wstring color_brand_word = L"#2a2a2a";
    static const std::wstring color_brand_slide = L"#2a2a2a";
    static const std::wstring color_brand_cell = L"#2a2a2a";

    static const std::wstring color_window_background = L"#404040";
    static const std::wstring color_window_border = L"#2a2a2a";

    static const std::wstring color_text_normal = L"#d9d9d9";
    static const std::wstring color_text_normal_pressed = L"#d9d9d9";

    static const std::wstring color_tool_button_hover_background = L"#555";
    static const std::wstring color_tool_button_pressed_background = L"#606060";

    static const std::wstring color_tab_active_background = L"#333";
    static const std::wstring color_tab_simple_active_background = L"#fff";
    static const std::wstring color_tab_simple_active_text = L"#444";
    static const std::wstring color_tab_default_active_background = L"#333";
    static const std::wstring color_tab_default_active_text = L"#fff";
    static const std::wstring color_tab_divider = L"#505050";

    static const QColor button_normal_opacity = QColor(255,255,255,200);
    static const std::wstring color_logo = L"light";
}

class CThemes
{
public:
    enum class ColorRole {
        ecrWindowBackground
        , ecrWindowBorder
        , ecrTextNormal
        , ecrTextPressed
        , ecrLogoColor
        , ecrTabWordActive
        , ecrTabCellActive
        , ecrTabSlideActive
        , ecrTabSimpleActiveBackground
        , ecrTabSimpleActiveText
        , ecrTabDefaultActiveBackground
        , ecrTabDefaultActiveText
    };
public:
    CThemes();
    ~CThemes();

    auto color(ColorRole r) -> QColor;
    auto color(const std::wstring& theme, ColorRole r) -> QColor;
#ifdef Q_OS_WIN
    auto colorRef(ColorRole r) -> COLORREF;
#endif
    auto value(ColorRole) -> std::wstring;
    auto value(const std::wstring&, ColorRole) -> std::wstring;
    auto current() -> std::wstring;
    auto setCurrent(const std::wstring&) -> void;
    auto isCurrent(const std::wstring& name) -> bool;
    auto isCurrentDark() -> bool;
    auto isThemeDark(const std::wstring& name) -> bool;

    auto isColorDark(ColorRole) -> bool;
    auto isColorDark(const std::wstring&) -> bool;
    auto isColorDark(const QString&) -> bool;

    auto parseThemeName(const std::wstring&) -> std::wstring;
private:
    class CThemesPrivate;
    CThemesPrivate * m_priv = nullptr;
};

#endif // CTHEMES_H
