#!/bin/bash

# Prepare updated reports
Rscript -e 'rmarkdown::render(input = "content/report.Rmd", output_file = "index.html")'
git add content/index.html
git commit -m 'Update html report'

# Move changes to gh-pages branch
git checkout gh-pages 
git checkout feature/species-diversity-report content/index.html
cp content/index.html . && rm content/index.html && rmdir content

# Clean up
git rm --cached content/index.html
git add index.html

# Commit
git commit -m 'Update html report'

# Return to develop
git checkout feature/species-diversity-report

# Publish
git push origin gh-pages
git push origin feature/species-diversity-report

