function office {
  coproc (libreoffice $@)
}

function office-new-doc {
  office --writer --norestore
}

