# ── cmd: setup ─────────────────────────────────────────────────

cmd_setup() {
    echo "=== cac setup ==="

    local real_claude
    real_claude=$(_find_real_claude)
    if [[ -z "$real_claude" ]]; then
        echo "错误：找不到 claude 命令，请先安装 Claude CLI" >&2
        echo "  npm install -g @anthropic-ai/claude-code" >&2
        exit 1
    fi
    echo "  真实 claude：$real_claude"

    mkdir -p "$ENVS_DIR"
    echo "$real_claude" > "$CAC_DIR/real_claude"

    local os; os=$(_detect_os)
    _write_wrapper
    _write_hostname_shim
    _write_ifconfig_shim

    if [[ "$os" == "macos" ]]; then
        _write_ioreg_shim
        echo "  ✓ ioreg shim → $CAC_DIR/shim-bin/ioreg"
    elif [[ "$os" == "linux" ]]; then
        _write_machine_id_shim
        echo "  ✓ machine-id shim → $CAC_DIR/shim-bin/cat"
    fi

    echo "  ✓ wrapper → $CAC_DIR/bin/claude"
    echo "  ✓ hostname shim → $CAC_DIR/shim-bin/hostname"
    echo "  ✓ ifconfig shim → $CAC_DIR/shim-bin/ifconfig"
    echo
    echo "── 下一步 ──────────────────────────────────────────────"
    echo "1. 将以下两行加到 ~/.zshrc 最前面："
    echo
    echo "   export PATH=\"\$HOME/bin:\$PATH\"          # cac 命令"
    echo "   export PATH=\"$CAC_DIR/bin:\$PATH\"  # claude wrapper"
    echo
    echo "2. source ~/.zshrc"
    echo
    echo "3. 添加第一个代理环境："
    echo "   cac add <名字> <host:port:user:pass>"
}
