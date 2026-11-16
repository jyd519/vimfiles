return {
  {
    "jyd519/ansible-vault-encrypt.nvim",
    opts = {
      -- Path to ansible-vault executable (default: "ansible-vault")
      executable = "ansible-vault",

      -- Keymap to toggle encrypt/decrypt (default: "<leader>av")
      -- Set to false to disable the keybinding entirely
      keymap = "<leader>av",

      -- Path to vault password file (bypasses ansible.cfg lookup)
      -- keyfile = nil,

      -- Path to ansible.cfg (bypasses auto-discovery)
      -- ansible_cfg = nil,

      -- Vault ID to use for encryption (skips the selection prompt)
      -- encrypt_vault_id = nil,
    },
  },
}
