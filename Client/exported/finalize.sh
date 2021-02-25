
shopt -s nullglob

root="doodads_medres"
cwd="$PWD"
for f in "$root"/*/; do
	cd "$f"
	if [ -d "diffuse" ]; then
	    montage diffuse/?.png diffuse/??.png -background none -tile 8 -geometry 256x256+0+0 diffuse.png
	    rm -rf diffuse
	fi
	if [ -d "normal" ]; then
	    montage normal/?.png normal/??.png -background none -tile 8 -geometry 256x256+0+0 normal.png
	    rm -rf normal
	fi
	cd "$cwd"
done



