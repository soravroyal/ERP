

:begin
/<source>.*<\/source>/ {
s/</\&lt;/g
s/>/\&gt;/g
s/&lt;source&gt;/<source>/g
s/&lt;\/source&gt;/<\/source>/g
b 
}
/<source>.*/ {
N
b begin
}
/<target>.*<\/target>/ {
s/</\&lt;/g
s/>/\&gt;/g
s/&quot;/\"/g
s/&lt;target&gt;/<target>/g
s/&lt;\/target&gt;/<\/target>/g
b 
}
/<target>.*/ {
N
b begin
}
