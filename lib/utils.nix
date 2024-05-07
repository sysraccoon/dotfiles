{ lib, ... }:

{
  impureSymlink = lib.file.mkOutOfStoreSymlink;
}
