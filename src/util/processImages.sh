# rename any file.JPG extension to file.jpg
for file in ../images/source/*.JPG
do
 mv "$file" "${file%.JPG}.jpg"
done

# process images
mogrify -path ../images -filter Triangle -define filter:support=2 -thumbnail 800 -unsharp 0.25x0.25+8+0.065 -dither None -posterize 136 -quality 82 -define jpeg:fancy-upsampling=off -define png:compression-filter=5 -define png:compression-level=9 -define png:compression-strategy=1 -define png:exclude-chunk=all -interlace none -colorspace sRGB -strip ../images/source/*.jpg

# append suffix to processed images
for file in ../images/*.jpg
do
  SUFFIX=$(echo $file | cut -d '_' -f 2)
  if [ "$SUFFIX" != "800.jpg" ]; then
    mv "$file" "${file%.jpg}_800.jpg"
  fi
done
