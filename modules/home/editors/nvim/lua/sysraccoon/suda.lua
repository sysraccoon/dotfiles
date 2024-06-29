return {
  "lambdalisue/suda.vim", -- Allow perform sudo commands inside vim (useful when edit RO file and want save changes)
  keys = {
    { mode = "ca", "W!", "SudaWrite" },
  },
}
