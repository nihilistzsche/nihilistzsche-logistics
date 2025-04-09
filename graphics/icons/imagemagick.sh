tiers="-pro -pro2"

for tier in $tiers
do
  if [ "$tier" = "emptystring" ]; then
      tier=""
  fi

  echo $tier
  magick splitter${tier}.png -crop 64x64+0+0 splitter${tier}-64x64.png

  magick splitter${tier}-64x64.png -crop 64x12+0+0 lane-splitter${tier}-top.png
  magick splitter${tier}-64x64.png -gravity South -crop 64x24+0+0 lane-splitter${tier}-bottom.png

  magick lane-splitter${tier}-top.png lane-splitter${tier}-bottom.png -alpha on -append lane-splitter${tier}-1x1.png
  magick lane-splitter${tier}-1x1.png -gravity center -background none -extent 64x64 lane-splitter${tier}.png
done

find . -type f -name "*-64x64.png" -delete
find . -type f -name "*-top.png" -delete
find . -type f -name "*-bottom.png" -delete
find . -type f -name "*-1x1.png" -delete
