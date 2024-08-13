# Keyboards, Layouts, Hotkeys

## Table of Contents {TOC}

<!-- toc-start -->

- [Spec](<#Spec>)
- [Programmable Layers {kanata}](<#Programmable Layers {kanata}>)
  - [Introduction](<#Introduction>)
  - [Setup](<#Setup>)
  - [Legend](<#Legend>)
  - [General](<#General>)
  - [Base Layer {@base}](<#Base Layer {@base}>)
  - [Navigation Layer {@navigation}](<#Navigation Layer {@navigation}>)
  - [Tmux Layer {@tmux}](<#Tmux Layer {@tmux}>)
  - [Tmux Movement Layer {@tmux-movement}](<#Tmux Movement Layer {@tmux-movement}>)
  - [TTY Layer {@tty}](<#TTY Layer {@tty}>)

<!-- toc-end -->

## Spec

- Keyboard: [HHKB professional 2](https://www.hhkeyboard.com/uk/products/pro2)
- Layouts: US(dvorak), RU(йцукен)
- Programmable features: [Kanata](https://github.com/jtroo/kanata)

## Programmable Layers {kanata}

### Introduction

Since HHKB 2 is not programmable (at least with a standard controller), I use Kanata as software
solution.

Information about all configuration options can be found in
[documentation](https://github.com/jtroo/kanata/blob/main/docs/config.adoc).

This section produce configuration file in `kbd` format, that used by kanata. Result file can be
found here: [default.kbd](../modules/combined/keyboard/kanata/default.kbd)

```{.kbd file=modules/combined/keyboard/kanata/default.kbd}
<<kanata-config-body>>
```


### Setup



### Legend

![layout-legend](../assets/keyboard-layouts/layout-legend.png)

### General

Configuration file **must** have exactly one `defsrc` entry. This defines the order of keys that the
`deflayer` and `deflayermap` entries will operate on.

`defsrc` block doesn't _necessarily_ have to coincide with actual input keyboard. I specify a full
100% `defsrc` block, but only use 60% keyboard. This will mean that every specified `deflayer` will
also have to match 100% `defsrc`, and that actual keyboard would be physically unable to trigger
about 40% of keymaps, but it allow easily apply this configuration to any other keyboard.

```{.kbd #kanata-config-body}
(defsrc
  esc  f1   f2   f3   f4   f5   f6   f7   f8   f9   f10  f11  f12        ssrq slck pause
  grv  1    2    3    4    5    6    7    8    9    0    [    ]    bspc  ins  home pgup  nlck kp/  kp*  kp-
  tab  '    ,    .    p    y    f    g    c    r    l    /    =    \     del  end  pgdn  kp7  kp8  kp9  kp+
  caps a    o    e    u    i    d    h    t    n    s    -    ret                        kp4  kp5  kp6
  lsft ;    q    j    k    x    b    m    w    v    z    rsft                 up         kp1  kp2  kp3  kprt
  lctl lmet lalt           spc            ralt rmet cmp  rctl            left down rght  kp0  kp.
)
```

Define timeouts for `tap-hold` bindings.

```{.kbd #kanata-config-body}
(defvar
  tap-timeout 100
  hold-timeout 200

  tt $tap-timeout
  ht $hold-timeout
)
```

Define layer switch aliases

```{.kbd #kanata-config-body}
(defalias
  nav (layer-while-held navigation)
  tty (layer-while-held tty)
  tmux (layer-while-held tmux)
  tmux-movement (layer-while-held tmux-movement)
)
```

### Base Layer {@base}

The base layer uses home-row mods and a modified escape position.

![hhkb-base-layer](../assets/keyboard-layouts/hhkb-base-layer.png)

Define aliases to easily access from `deflayer`.

```{.kbd #kanata-config-body}
(defalias
  lctl (tap-hold $tt $ht esc lctl)
  a (tap-hold-release $tt $ht a lalt)
  o (tap-hold-release $tt $ht o lmet)
  e (tap-hold-release $tt $ht e lsft)
  u (tap-hold-release $tt $ht u lctl)
  h (tap-hold-release $tt $ht h rctl)
  t (tap-hold-release $tt $ht t rsft)
  n (tap-hold-release $tt $ht n rmet)
  s (tap-hold-release $tt $ht s ralt)
  spc (tap-hold $tt $ht spc @nav)
  lalt @tmux
)
```

Define base layer (should be first defined layer in configuration file)

```{.kbd #kanata-config-body}
(deflayer base
  esc  f1   f2   f3   f4   f5   f6   f7   f8   f9   f10  f11  f12        ssrq slck pause
  grv  1    2    3    4    5    6    7    8    9    0    [    ]    bspc  ins  home pgup  nlck kp/  kp*  kp-
  tab  '    ,    .    p    y    f    g    c    r    l    /    =    \     del  end  pgdn  kp7  kp8  kp9  kp+
  @lctl @a @o   @e   @u    i    d   @h   @t   @n   @s    -    ret                        kp4  kp5  kp6
  lsft ;    q    j    k    x    b    m    w    v    z    rsft                 up         kp1  kp2  kp3  kprt
  @lctl lmet @lalt           @spc            ralt rmet cmp  rctl            left down rght  kp0  kp.
)
```

### Navigation Layer {@navigation}

![hhkb-navigation-layer](../assets/keyboard-layouts/hhkb-navigation-layer.png)

```{.kbd #kanata-config-body}
(deflayermap (navigation)
  lalt @tty

  m C-S-tab ;; previous tab
  w C-tab ;; next tab

  p C-v ;; paste
  y C-c ;; yank/copy
  u C-z ;; undo
  x C-x ;; cut

  g pgdn
  r pgup

  c up
  h left
  t down
  n rght

  d C-left
  s C-rght

  b home
  v end

  1 f1
  2 f2
  3 f3
  4 f4
  5 f5
  6 f6
  7 f7
  8 f8
  9 f9
  0 f10
  [ f11
  ] f12
)
```

### Tmux Layer {@tmux}

![hhkb-tmux-layer](../assets/keyboard-layouts/hhkb-tmux-layer.png)

```{.kbd #kanata-config-body}
(defvar
  tmux-leader C-spc
)

(deflayermap (tmux)
  spc @tty
  lsft @tmux-movement

  b (macro $tmux-leader i) ;; create new window
  m (macro $tmux-leader C-p) ;; focus previous window
  w (macro $tmux-leader C-n) ;; focus next window

  g (macro $tmux-leader S-q) ;; split pane vertical
  r (macro $tmux-leader S-5) ;; split pane horizontal

  d (macro $tmux-leader d) ;; detach from session

  c C-k ;; tmux-vim-navigation up
  h C-h ;; tmux-vim-navigation left
  t C-j ;; tmux-vim-navigation down
  n C-l ;; tmux-vim-navigation right

  x (macro $tmux-leader x) ;; close pane
  z (macro $tmux-leader z) ;; zoom pane
)
```

### Tmux Movement Layer {@tmux-movement}

![hhkb-tmux-movement-layer](../assets/keyboard-layouts/hhkb-tmux-movement-layer.png)

```{.kbd #kanata-config-body}
(deflayermap (tmux-movement)
  h (macro $tmux-leader S-[) ;; move pane left
  n (macro $tmux-leader S-]) ;; move pane right

  m (macro $tmux-leader C-S-p) ;; move window left
  w (macro $tmux-leader C-S-n) ;; move window right
)
```

### TTY Layer {@tty}

Used to quickly switch between linux tty's.

![hhkb-tty-layer](../assets/keyboard-layouts/hhkb-tty-layer.png)

```{.kbd #kanata-config-body}
(deflayermap (tty)
  1 C-A-f1
  2 C-A-f2
  3 C-A-f3
  4 C-A-f4
  5 C-A-f5
  6 C-A-f6
  7 C-A-f7
)
```
