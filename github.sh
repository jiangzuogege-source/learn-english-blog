#!/bin/bash
##github部署脚本
npm run build
cd public
git init
git remote add origin git@github.com:doobo/doobo.github.io.git
git add .
git commit -m "更新博客"
git push --set-upstream origin master -f