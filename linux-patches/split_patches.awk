#!/usr/bin/gawk -f
BEGIN {
  crnt_fname = "";
}

/^diff -Naurp.* b\/linux-[0-9.]*.igel\// {
  s = $0;
  if (gsub("^.* b/linux-[0-9.]*\\.igel/", "", s) > 0 && length(s) > 0) {
    gsub("/", "_", s);
    crnt_fname = "patches/" s ".diff";
  }
}

{
  if (length(crnt_fname) > 0) {
    print $0 >>crnt_fname;
  }
}
