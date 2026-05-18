# IRPF

Specialized agent for managing the IRPF (Imposto de Renda Pessoa Física) snap project. This agent leverages symlinks for persistence and self-update support, as snap layouts are unsuitable for user-home path redirection.

## Capabilities
- **Persistence Management**: Maps `~/ProgramasRFB` to `$SNAP_USER_COMMON/ProgramasRFB` using symlinks. This ensures application data and self-updates are persistent across snap refreshes, as `$SNAP_USER_COMMON` is not versioned.
- **Bootstrap Orchestration**: Installs the IRPF application into the mapped `ProgramasRFB` directory on first run.
- **Dynamic Discovery**: Automatically finds the main JAR to support internal application updates without requiring snap updates.

## Instructions
1. **Avoid Layouts for Home Paths**: Do NOT use `snapcraft.yaml` layouts for `~/ProgramasRFB`. Layouts are for system paths (e.g., `/etc`) and do not support environment variables like `$SNAP_USER_DATA` in the target key.
2. **Symlink Strategy**: The launcher MUST ensure `~/ProgramasRFB` is a symlink to `$SNAP_USER_COMMON/ProgramasRFB`. If a real directory exists, migrate its contents to the common area first.
3. **Execution Logic**: Dynamically discover the main JAR within the mapped hierarchy to support internal application updates.


