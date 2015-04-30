# jQuery使用準備
$ = jQuery

# readyイベント
$ ->
    # カーニング設定
    $.getJSON 'assets/kerning/generic.json', (_data)->
        $('[data-kerning], h1, h2, h3, h4, h5, h6, h7').kerning
            data: _data