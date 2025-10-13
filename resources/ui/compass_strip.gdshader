shader_type canvas_item;

// przesunięcie tekstury (np. rośnie, gdy obracamy kamerę)
uniform float offset_x = 0.0;
// 0.5 = połowa tekstury widoczna
uniform float visible_portion = 0.5;
// miękkie zanikanie na brzegach
uniform float fade_width = 0.1;



void fragment() {
    // zakres widocznego fragmentu w środku
    float start = 0.5 - visible_portion * 0.5;
    float end = 0.5 + visible_portion * 0.5;

    // zamiast przesuwać wycinek — przesuwamy UV wewnątrz tekstury
    float scrolled_u = fract(UV.x + offset_x);

    // próbkuj teksturę przesuniętą o offset
    vec4 tex_color = texture(TEXTURE, vec2(scrolled_u, UV.y));

    // oblicz fade na krawędziach ramki (która jest nieruchoma)
    float fade = 1.0;
    if (UV.x < start + fade_width)
        fade = smoothstep(start, start + fade_width, UV.x);
    else if (UV.x > end - fade_width)
        fade = smoothstep(end, end - fade_width, UV.x);

    // wyzeruj alfa poza ramką
    if (UV.x < start || UV.x > end)
        tex_color.a = 0.0;

    // zastosuj fade
    tex_color.a *= fade;

    COLOR = tex_color;
}
