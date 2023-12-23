# Panadestein's Nushell Env

$env.STARSHIP_SHELL = "nu"

def create_left_prompt [] {
    # Colors of the integral
    let braket_color = (if (is-admin) { ansi red_bold } else { ansi light_green_bold })
    let path_color = (if (is-admin) { ansi red_bold } else { ansi green_bold })
    let separator_color = (if (is-admin) { ansi light_red_bold } else { ansi light_green_bold })
    # Vectors
    let bra = $"($braket_color)⟨"
    let nushell = "ν"
    let hamiltonian = " | "
    let dir = ($env.PWD | path basename)
    let ket = $"($braket_color)⟩"
    let path_segment = $"($bra)($path_color)($nushell)(ansi white_bold)($hamiltonian)($path_color)($dir)($ket)"
    $path_segment
}

# Use nushell functions to define your right and left prompt
$env.PROMPT_COMMAND = {|| create_left_prompt }
$env.PROMPT_COMMAND_RIGHT = {|| "" }

# Set prompt indicator
$env.PROMPT_INDICATOR = {|| " " }
$env.PROMPT_INDICATOR_VI_INSERT = {|| " " }
$env.PROMPT_INDICATOR_VI_NORMAL = {|| " " }
$env.PROMPT_MULTILINE_INDICATOR = {|| "::: " }

# Specifies how environment variables are
$env.ENV_CONVERSIONS = {
    "PATH": {
        from_string: { |s| $s | split row (char esep) | path expand --no-symlink }
        to_string: { |v| $v | path expand --no-symlink | str join (char esep) }
    }
    "Path": {
        from_string: { |s| $s | split row (char esep) | path expand --no-symlink }
        to_string: { |v| $v | path expand --no-symlink | str join (char esep) }
    }
}

# Directories to search for scripts when calling source or use
$env.NU_LIB_DIRS = [
    ($nu.default-config-dir | path join 'scripts')
]

# Directories to search for plugin binaries when calling register
$env.NU_PLUGIN_DIRS = [
    ($nu.default-config-dir | path join 'plugins')
]