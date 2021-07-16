# ---------------------------------------------------------------------------------------------------------------------
# Multi-language
# ---------------------------------------------------------------------------------------------------------------------
# Functionality to overwrite all user facing text of the stack
locals {
  lang = {
    en = local.i18n_en
    fr = local.i18n_fr
  }

  i18n = merge(local.lang.en, try(local.lang[var.lang], var.lang))
}
