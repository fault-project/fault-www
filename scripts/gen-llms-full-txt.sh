find docs -type f -name "*.md" -print0 \
  | sort -z \
  | xargs -0 awk '
    BEGIN { in_frontmatter=0 }
    FNR==1 { in_frontmatter=0 }
    /^---$/ && FNR==1 { in_frontmatter=1; next }
    /^---$/ && in_frontmatter { in_frontmatter=0; next }
    !in_frontmatter { print }
  ' > docs/assets/llms-full.txt
