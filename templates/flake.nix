{
  inputs = {
    c-template.url = "path:./c";
  };

  outputs = inputs: {
    templates = with inputs; {
      c = c-template.templates.default;
    };
  };
}
